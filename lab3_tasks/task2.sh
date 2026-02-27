#! /usr/bin/bash

read -p "Enter domain or directory name of your choice: " d_name
sudo mkdir /var/www/$d_name

sudo touch /etc/apache2/sites-available/$d_name.conf

cat <<- EOF > /etc/apache2/sites-available/$d_name.conf
<VirtualHost *:83>
	# The ServerName directive sets the request scheme, hostname and port that
	# the server uses to identify itself. This is used when creating
	# redirection URLs. In the context of virtual hosts, the ServerName
	# specifies what hostname must appear in the request's Host: header to
	# match this virtual host. For the default virtual host (this file) this
	# value is not decisive as it is used as a last resort host regardless.
	# However, you must set it for any further virtual host explicitly.
	#ServerName www.example.com

	ServerAdmin webmaster@localhost
	DocumentRoot /var/www/$d_name

	# Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
	# error, crit, alert, emerg.
	# It is also possible to configure the loglevel for particular
	# modules, e.g.
	#LogLevel info ssl:warn

	ErrorLog ${APACHE_LOG_DIR}/error.log
	CustomLog ${APACHE_LOG_DIR}/access.log combined

	# For most configuration files from conf-available/, which are
	# enabled or disabled at a global level, it is possible to
	# include a line for only one particular virtual host. For example the
	# following line enables the CGI configuration for this host only
	# after it has been globally disabled with "a2disconf".
	#Include conf-available/serve-cgi-bin.conf
</VirtualHost>
EOF

sudo touch /var/www/$d_name/index.html
sudo a2ensite $d_name.conf
cat <<- EOF > /var/www/$d_name/index.html
<!DOCTYPE html>
<html>
<body>
    <h1>Website Deployed!</h1>
    <p>This is a test page for my Apache virtual host setup.</p>
</body>
</html>
EOF

sudo systemctl reload apache2

echo "Script ended!"
