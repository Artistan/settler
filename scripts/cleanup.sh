
# One last upgrade check

apt-get -y upgrade

# Clean Up

apt-get -y autoremove
apt-get -y clean
chown -R vagrant:vagrant /home/vagrant

# Enable Swap Memory

/bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024
/sbin/mkswap /var/swap.1
/sbin/swapon /var/swap.1

apt-get -y autoremove;
apt-get -y clean;