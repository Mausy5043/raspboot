echo "Set permissions... [nut]"
sudo chmod 0640 /etc/nut/*

echo "Modify /boot/config.txt "
# Scaled CPU frequency
echo ""                         | sudo tee -a /boot/config.txt
echo "# Added by raspboot"      | sudo tee -a /boot/config.txt
echo "arm_freq=950"             | sudo tee -a /boot/config.txt
echo "core_freq=450"            | sudo tee -a /boot/config.txt
echo "sdram_freq=450"           | sudo tee -a /boot/config.txt
echo "over_voltage=6"           | sudo tee -a /boot/config.txt
echo ""                         | sudo tee -a /boot/config.txt
echo "arm_freq_min=500"         | sudo tee -a /boot/config.txt
echo "core_freq_min=250"        | sudo tee -a /boot/config.txt
echo "sdram_freq_min=400"       | sudo tee -a /boot/config.txt
echo "over_voltage_min=0"       | sudo tee -a /boot/config.txt
echo ""                         | sudo tee -a /boot/config.txt
echo "force_turbo=0"            | sudo tee -a /boot/config.txt
echo "temp_limit=70"            | sudo tee -a /boot/config.txt
echo "[OK]"

echo "Add mountpoint for external HDD "
sudo mkdir -p /mnt/icybox
echo "/dev/sda1 /mnt/icybox ext4 defaults  0   2"       | sudo tee -a /etc/fstab
sudo mount /mnt/icybox
echo

echo "Configuring Deluge"
# add user pi to the Deluge group
sudo adduser pi debian-deluged
# set permissions for the new services
sudo chmod 644 /etc/systemd/system/deluge*
# create the .config directory
sudo mkdir /var/lib/deluged/.config
# copy the configuration files
sudo cp -R /mnt/icybox/config/* /var/lib/deluged/.config/
# own the files...
sudo chown -R debian-deluged:debian-deluged /var/lib/deluged/.config
# ...and set permissions
sudo chmod -R 774 /var/lib/deluged/.config

# ref: http://dev.deluge-torrent.org/wiki/UserGuide/Service/systemd
# Next line is already executed by the package installer
# sudo adduser --system  --gecos "Deluge Service" --disabled-password --group --home /var/lib/deluge debian-deluged

# logging on external HDD is already existing

# stop and remove old init-script
sudo /etc/init.d/deluged stop
sudo rm /etc/init.d/deluged
sudo update-rc.d deluged remove

# Enable, Start and Check the daemon
sudo systemctl enable /etc/systemd/system/deluged.service
sudo systemctl start deluged
sudo systemctl status deluged

# Enable, Start and Check the web-daemon
sudo systemctl enable /etc/systemd/system/deluge-web.service
sudo systemctl start deluge-web
sudo systemctl status deluge-web

# Restart the daemons
sudo systemctl restart deluged
sudo systemctl restart deluge-web

echo
