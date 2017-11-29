#!/usr/bin/env bash

# add elasticsearch to the apt list
sudo wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -;
echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list;
sudo apt-get update

# main packages needed.
sudo apt-get --assume-yes install default-jre
sudo apt-get --assume-yes install htop
sudo apt-get --assume-yes install mytop
sudo apt-get --assume-yes install zsh
sudo apt-get --assume-yes install jq
sudo apt-get --assume-yes install memcached
sudo apt-get --assume-yes install php-memcached
sudo apt-get --assume-yes install elasticsearch
sudp apt-get --assume-yes install python3
sudp apt-get --assume-yes install python3-dev
sudp apt-get --assume-yes install python3-pip


# Install oh-my-zsh theme
git clone https://github.com/Artistan/powerlevel9k.git /home/vagrant/.oh-my-zsh/custom/themes/powerlevel9k
cd /home/vagrant/.oh-my-zsh/custom/themes/powerlevel9k; git checkout color_names;
printf "\nsource ~/.bash_aliases\n" | tee -a /home/vagrant/.zshrc

# pip it out... thefuck you say
sudo pip3 install --upgrade pip3
pip3 install thefuck

# enable xdebug mod
sudo phpenmod xdebug;
mkdir -p /home/vagrant/Code/xdebug
sudo nginx -s reload
sudo service php7.1-fpm restart;

# setup elasticsearch service and cluster.
sudo systemctl enable elasticsearch.service;
sudo chmod -R 777 /etc/elasticsearch;
sudo echo 'cluster.name: Homestead' >> /etc/elasticsearch/elasticsearch.yml;
sudo echo 'network.host: ["_local_","_site_"]' >> /etc/elasticsearch/elasticsearch.yml;
sudo echo 'path.repo: "/tmp/repositories"' >> /etc/elasticsearch/elasticsearch.yml;
sudo chmod 644 /etc/elasticsearch/*;
sudo chmod 755 /etc/elasticsearch;
sudo systemctl restart elasticsearch

# make sure memcached will start
sudo systemctl enable memcached.service
sudo systemctl start memcached.service

# template files...
cd /home/vagrant
sudo wget --no-cookies --no-check-certificate -O .zshrc https://raw.githubusercontent.com/Artistan/settler/elastic/virtualbox-elastic-plus/templates/template.zshrc
sudo wget --no-cookies --no-check-certificate -O .my.cnf https://raw.githubusercontent.com/Artistan/settler/elastic/virtualbox-elastic-plus/templates/template.my.cnf
cd /etc/php/7.1/fpm/conf.d/
sudo wget --no-cookies --no-check-certificate -O 20-xdebug.ini https://raw.githubusercontent.com/Artistan/settler/elastic/virtualbox-elastic-plus/templates/xdebug.ini

cd /home/vagrant/;

# own it.
sudo chown -R vagrant:vagrant /home/vagrant
echo "install complete"