#!/usr/bin/bash

new_user="devopsuser"

sudo mkdir -p /home/$new_user/.ssh
sudo ssh-keygen -t rsa -f /home/$new_user/.ssh/id_rsa -N "" -q
sudo chmod 700 /home/$new_user/.ssh
sudo chmod 600 /home/$new_user/.ssh/id_rsa

cat /home/$new_user/.ssh/id_rsa.pub | sudo tee /home/$new_user/.ssh/authorized_keys
sudo chown -R $new_user:$new_user /home/$new_user/.ssh

target_file="/etc/ssh/sshd_config"

if grep -q "PasswordAuthentication" $target_file; then
    sudo sed -i "/PasswordAuthentication/c PasswordAuthentication no" $target_file
else
    echo "PasswordAuthentication no" | sudo tee -a $target_file
fi

sudo systemctl reload ssh

sudo touch /home/$new_user/.ssh/config
sudo chown -R $new_user:$new_user /home/$new_user/.ssh/config
sudo chmod 600 /home/$new_user/.ssh/config
sudo tee -a /home/$new_user/.ssh/config <<EOF
Host devopsuser
    Hostname 127.0.0.1
    User $new_user
    IdentityFile /home/$new_user/.ssh/id_rsa
EOF

sudo -u $new_user ssh -T devopsuser << COMMANDS
mkdir ~/test
touch ~/test/filecreatedinnoninteractivemode.txt
echo "I am doing the task3." >> ~/test/filecreatedinnoninteractivemode.txt
COMMANDS

echo "Successfully done!"




