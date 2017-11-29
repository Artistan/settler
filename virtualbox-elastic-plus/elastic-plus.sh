#!/usr/bin/env bash

# add elasticsearch to the apt list
sudo wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -;
echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list;
sudo apt-get update

./powerline.sh

# main packages needed.
sudo apt-get --assume-yes install wget default-jre htop mytop zsh jq memcached php-memcached elasticsearch pip

# template files...
cd /home/vagrant
wget --no-cookies --no-check-certificate -O .zshrc https://raw.githubusercontent.com/Artistan/settler/elastic/virtualbox-elastic-plus/templates/template.zshrc
wget --no-cookies --no-check-certificate -O .my.cnf https://raw.githubusercontent.com/Artistan/settler/elastic/virtualbox-elastic-plus/templates/template.my.cnf
cd /etc/php/7.1/fpm/conf.d/
wget --no-cookies --no-check-certificate -O 20-xdebug.ini https://raw.githubusercontent.com/Artistan/settler/elastic/virtualbox-elastic-plus/templates/xdebug.ini

# Install oh-my-zsh
git clone https://github.com/Artistan/powerlevel9k.git /home/vagrant/.oh-my-zsh/custom/themes/powerlevel9k
cd /home/vagrant/.oh-my-zsh/custom/themes/powerlevel9k; git checkout color_names;
printf "\nsource ~/.bash_aliases\n" | tee -a /home/vagrant/.zshrc
chsh -s /usr/bin/zsh vagrant

# pip it out... thefuck you say
sudo pip install --upgrade pip
pip install thefuck

# enable xdebug mod
sudo phpenmod xdebug;
dir -p /home/vagrant/Code/xdebug
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

cd /home/vagrant/;

touch 'aftermath'
# own it.
chown -R vagrant:vagrant /home/vagrant
echo "install complete"