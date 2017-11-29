#!/usr/bin/env bash

# main packages needed.
sudo apt-get --assume-yes install wget htop mytop zsh jq pip

sudo apt-get --assume-yes install htop
sudo apt-get --assume-yes install mytop
sudo apt-get --assume-yes install zsh
sudo apt-get --assume-yes install jq
sudp apt-get --assume-yes install python3
sudp apt-get --assume-yes install python3-dev
sudp apt-get --assume-yes install python3-pip


# Install oh-my-zsh
git clone https://github.com/Artistan/powerlevel9k.git /home/vagrant/.oh-my-zsh/custom/themes/powerlevel9k
cd /home/vagrant/.oh-my-zsh/custom/themes/powerlevel9k; git checkout color_names;
printf "\nsource ~/.bash_aliases\n" | tee -a /home/vagrant/.zshrc

# pip it out... thefuck you say
sudo pip3 install --upgrade pip3
pip3 install thefuck

# https://stackoverflow.com/a/37331750/372215 --- allow for external use, the virtualbox can take care of "security" this is just for dev.
sudo sed -i /etc/redis/redis.conf.original 's/^protected-mode.*/protected-mode no/' /etc/redis/redis.conf
sudo sed -i '' 's/^bind/#bind/' /etc/redis/redis.conf
# make sure redis will start
sudo systemctl enable redis.service

# template files...
cd /home/vagrant
sudo wget --no-cookies --no-check-certificate -O .zshrc https://raw.githubusercontent.com/Artistan/settler/elastic/virtualbox-elastic-plus/templates/template.zshrc
sudo wget --no-cookies --no-check-certificate -O .my.cnf https://raw.githubusercontent.com/Artistan/settler/elastic/virtualbox-elastic-plus/templates/template.my.cnf

cd /home/vagrant/;

# own it.
sudo chown -R vagrant:vagrant /home/vagrant
echo "install complete"