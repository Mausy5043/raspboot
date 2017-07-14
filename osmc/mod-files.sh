# `osmc` requires more set-up because it is not spawned from raspbian-ua-netinst

echo -n "Stopping the MediaCenter... "
sudo systemctl stop mediacenter
if [ $? -eq 0 ]; then
    echo "[OK]"
else
    echo "[FAILED!]"
fi

# Because OSMC gets installed manually, we need to ketchup with the installation
# of the other Raspberry Pi servers.
# So we start by doing some stuff that was performed by the `raspbian-ua-netinst`
# installer and that we missed.

# Set the flag for `raspboot`
echo "master" > $HOME/.raspboot.branch
# Note: cronjobs may not start until after the reboot!
sudo crontab -u osmc $HOME/.crntb

sudo usermod -a -G systemd-journal osmc

# Create the mountpoints (just to be safe we create them all)
echo "Creating mountpoints ..."
sudo mkdir -p /mnt/backup
sudo mkdir -p /mnt/media
sudo mkdir -p /mnt/share1

# Creating a number of directories
echo "Create other directories..."
mkdir -m 0700 -p $HOME/.ssh
mkdir -m 0755 -p $HOME/bin

# Add mountpoints to /etc/fstab
echo "Adding mountpoints to /etc/fstab ..."
echo '# mountpoint for NFS on /mnt/media'  | sudo tee --append /etc/fstab
echo 'boson:/srv/array1/video    /mnt/media     nfs  defaults,user,noatime,intr,_netdev,x-systemd.automount,noauto    0    0'  | sudo tee --append /etc/fstab
echo '# mountpoint for systemlogs and backups'  | sudo tee --append /etc/fstab
echo 'boson:/srv/array1/backup   /mnt/backup    nfs4  nouser,atime,rw,dev,exec,suid,noauto,intr,_netdev    0    0'  | sudo tee --append /etc/fstab
echo 'tmpfs    /tmp        tmpfs    nodev,nosuid,size=64M,mode=1777    0    0'  | sudo tee --append /etc/fstab
echo 'tmpfs    /var/log    tmpfs    defaults,noatime,nosuid,mode=0755,size=96M    0    0'  | sudo tee --append /etc/fstab

echo "Removing AVAHI services we don't offer..."
sudo rm /etc/avahi/services/sftp.service

# Mount networkdisk
echo "Restoring from backup ..."
echo -n "Mount - "
sudo mount /mnt/backup
if [ $? -eq 0 ]; then
    echo "[OK]"
else
    echo "[FAILED!]"
fi

# We already retrieved the contents of `~/bin` from "rbmain" in `01-post-boot.sh`

# First move aside the existing `.kodi` folder
echo "Moving original .kodi folder out of the way..."
mv $HOME/.kodi $HOME/.kodi-org
echo "Recovering backup of .kodi folder..."
cp -vr /mnt/backup/osmc/home/osmc/.kodi $HOME/.kodi 2>/dev/null

sudo umount /mnt/backup
sudo umount /mnt/share1
sudo umount /mnt/media
