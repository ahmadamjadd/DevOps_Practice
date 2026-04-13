#!/usr/bin/bash

# Q3: Configure key-based SSH login for devopsuser and run remote commands.

new_user="devopsuser"

# Create .ssh directory and generate RSA key pair for the user.
sudo mkdir -p /home/$new_user/.ssh
sudo ssh-keygen -t rsa -f /home/$new_user/.ssh/id_rsa -N "" -q
sudo chmod 700 /home/$new_user/.ssh
sudo chmod 600 /home/$new_user/.ssh/id_rsa

# Authorize generated public key for passwordless local SSH testing.
cat /home/$new_user/.ssh/id_rsa.pub | sudo tee /home/$new_user/.ssh/authorized_keys
sudo chown -R $new_user:$new_user /home/$new_user/.ssh

# Disable password authentication in sshd_config.
target_file="/etc/ssh/sshd_config"

if grep -q "PasswordAuthentication" $target_file; then
    sudo sed -i "/PasswordAuthentication/c PasswordAuthentication no" $target_file
else
    echo "PasswordAuthentication no" | sudo tee -a $target_file
fi

# Reload SSH daemon to apply auth configuration.
sudo systemctl reload ssh

# Add host alias so user can SSH without typing username/IP each time.
sudo touch /home/$new_user/.ssh/config
sudo chown -R $new_user:$new_user /home/$new_user/.ssh/config
sudo chmod 600 /home/$new_user/.ssh/config
sudo tee -a /home/$new_user/.ssh/config <<EOF
Host devopsuser
    Hostname 127.0.0.1
    User $new_user
    IdentityFile /home/$new_user/.ssh/id_rsa
EOF

# Execute required file-creation tasks in non-interactive SSH mode.
sudo -u $new_user ssh -T devopsuser << COMMANDS
mkdir ~/test
touch ~/test/filecreatedinnoninteractivemode.txt
echo "I am doing the task3." >> ~/test/filecreatedinnoninteractivemode.txt
COMMANDS

echo "Successfully done!"




