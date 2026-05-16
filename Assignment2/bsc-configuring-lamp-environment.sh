#!/bin/bash

LOG_FILE="lamp-setup-2023361.log"

log() {
    local timestamp=$(date +'%Y-%m-%d %H:%M:%S')
    local message="$1"
    echo "[$timestamp] $message" | tee -a "$LOG_FILE"
}

ACTION=""
WEBSERVER="Apache" 

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -i) ACTION="install"; shift ;;
        -d) ACTION="delete"; shift ;;
        -ws) WEBSERVER="$2"; shift 2 ;;
        *)
            log "WARNING: Unknown command line option passed: $1"
            echo "Usage: $0 [-i] [-d] [-ws <Apache|Nginx>]"
            exit 1
            ;;
    esac
done

if [[ "$EUID" -ne 0 ]]; then
    log "ERROR: Script execution attempted without root privileges."
    echo "Error: Please run this script with sudo or as root."
    exit 1
fi

log "Start of script execution."

if [[ "$ACTION" == "install" ]]; then
    
    PREV_SERVER=""
    if apt list --installed 2>/dev/null | grep -q "^apache2"; then PREV_SERVER="Apache"; fi
    if apt list --installed 2>/dev/null | grep -q "^nginx"; then PREV_SERVER="Nginx"; fi

    SKIP_WS=0
    if [[ -n "$PREV_SERVER" ]]; then
        echo "$PREV_SERVER web server is already installed."
        read -p "Do you want to remove the previous server? (Y/n): " REMOVE_PREV
        
        if [[ "$REMOVE_PREV" =~ ^[Yy]$ ]]; then
            log "WARNING: Uninstalling previously installed $PREV_SERVER web server..."
            if [[ "$PREV_SERVER" == "Apache" ]]; then
                DEBIAN_FRONTEND=noninteractive apt-get purge -y apache2 apache2-utils apache2-bin > /dev/null 2>&1
            else
                DEBIAN_FRONTEND=noninteractive apt-get purge -y nginx nginx-common > /dev/null 2>&1
            fi
            DEBIAN_FRONTEND=noninteractive apt-get autoremove -y > /dev/null 2>&1
            log "$PREV_SERVER uninstalled successfully."
        else
            log "WARNING: User chose to keep existing $PREV_SERVER. Skipping installation."
            SKIP_WS=1
        fi
    fi

    if [[ "$SKIP_WS" -eq 0 ]]; then
        apt-get update -y > /dev/null 2>&1
        if [[ "${WEBSERVER,,}" == "nginx" ]]; then
            log "Installing Nginx Web Server..."
            if DEBIAN_FRONTEND=noninteractive apt-get install -y nginx > /dev/null 2>&1; then
                log "Nginx installed successfully."
            else
                log "ERROR: Failed to install Nginx."
            fi
        else
            log "Installing Apache Web Server..."
            if DEBIAN_FRONTEND=noninteractive apt-get install -y apache2 > /dev/null 2>&1; then
                log "Apache installed successfully."
            else
                log "ERROR: Failed to install Apache."
            fi
        fi
    fi

    if [[ "${WEBSERVER,,}" == "nginx" ]]; then PHP_CHECK="php-fpm"; else PHP_CHECK="libapache2-mod-php"; fi

    if apt list --installed 2>/dev/null | grep -q "^$PHP_CHECK"; then
        PHP_VER=$(php -v | head -n 1 | cut -d ' ' -f 2)
        log "WARNING: PHP and $PHP_CHECK already exist (Version: $PHP_VER)."
        echo "PHP is already configured for $WEBSERVER."
    else
        log "Installing PHP modules for $WEBSERVER..."
        if [[ "${WEBSERVER,,}" == "nginx" ]]; then
            DEBIAN_FRONTEND=noninteractive apt-get install -y php php-fpm php-mysql php-json php-curl php-gd php-xml php-mbstring > /dev/null 2>&1
            # AUTO-CONFIG NGINX FOR PHP
            log "Configuring Nginx PHP processing..."
            PHP_V=$(php -v | head -n 1 | cut -d ' ' -f 2 | cut -d . -f 1,2)
            cat <<EOF > /etc/nginx/sites-available/default
server {
    listen 80 default_server;
    root /var/www/html;
    index index.php index.html;
    server_name _;
    location / { try_files \$uri \$uri/ =404; }
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php\${PHP_V}-fpm.sock;
    }
}
EOF
            systemctl restart nginx > /dev/null 2>&1
        else
            DEBIAN_FRONTEND=noninteractive apt-get install -y php libapache2-mod-php php-mysql php-json php-curl php-gd php-xml php-mbstring > /dev/null 2>&1
        fi
        log "PHP installed successfully."
    fi

    if apt list --installed 2>/dev/null | grep -q "^mysql-server"; then
        log "WARNING: MySQL already installed. Skipping."
    else
        log "Installing MySQL..."
        if DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server > /dev/null 2>&1; then
            ROOT_PASS=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 16)
            mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH caching_sha2_password BY '$ROOT_PASS';" || \
            mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$ROOT_PASS';"
            echo "MySQL Root Password: $ROOT_PASS"
            log "MySQL installed. Password generated."
        else
            log "ERROR: MySQL installation failed."
        fi
    fi

    log "Creating index.php test page..."
    [ -f /var/www/html/index.html ] && mv /var/www/html/index.html /var/www/html/index.html.bak
    cat << 'EOF' > /var/www/html/index.php
<?php echo "<h1>Hello World!</h1><p>LAMP Stack Configured for Reg: 2023361</p>"; phpinfo(); ?>
EOF
    chown -R www-data:www-data /var/www/html/
    log "index.php created."

elif [[ "$ACTION" == "delete" ]]; then
    
    echo "================================================================="
    echo " WARNING: This will delete Apache, Nginx, PHP, and MySQL."
    echo " CRITICAL: BACKUP YOUR DATA BEFORE CONTINUING!"
    echo "================================================================="
    
    # 7b(iv). Log the warning about backups as required
    log "WARNING: Deletion process initiated. User warned about backups."
    
    read -p "Are you sure, you want to continue ... (Y/n): " CONFIRM_DEL
    
    if [[ "$CONFIRM_DEL" =~ ^[Yy]$ ]]; then
        log "User confirmed deletion. Removing services..."
        
        log "WARNING: Uninstalling Apache Web Server..."
        DEBIAN_FRONTEND=noninteractive apt-get purge -y apache2 apache2-* > /dev/null 2>&1
        
        log "WARNING: Uninstalling Nginx Web Server..."
        DEBIAN_FRONTEND=noninteractive apt-get purge -y nginx nginx-* > /dev/null 2>&1
        
        log "WARNING: Uninstalling PHP and all extensions..."
        DEBIAN_FRONTEND=noninteractive apt-get purge -y php* > /dev/null 2>&1
        
        log "WARNING: Uninstalling MySQL Server and configuration..."
        DEBIAN_FRONTEND=noninteractive apt-get purge -y mysql-server mysql-client mysql-common > /dev/null 2>&1
        
        DEBIAN_FRONTEND=noninteractive apt-get autoremove -y > /dev/null 2>&1
        log "Removal of all services completed successfully."
    else
        log "WARNING: Deletion aborted by user."
    fi

else
    log "ERROR: No valid action provided."
fi

log "End of script execution."
