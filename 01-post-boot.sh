#! /bin/bash

# This script only gets executed if `/tmp/raspboot.reboot` is absent...
# /tmp is in RAMFS, so everytime the server is rebooted, this script is executed.

CLNT=$(hostname)
ME=$(whoami)

# /var/log is on tmpfs so recreate lastlog now
if [ ! -e /var/log/lastlog ]; then
  sudo touch /var/log/lastlog
  sudo chgrp utmp /var/log/lastlog
  sudo chmod 664 /var/log/lastlog
fi

if [ ! -f $HOME/.my.cnf ]; then
  cp -rv  $HOME/bin/.config/.my.cnf $HOME/
  chmod    0740 $HOME/.my.cnf
fi
if [ ! -f $HOME/.netrc ]; then
  cp -rv  $HOME/bin/.config/.netrc  $HOME/
  chmod    0600 $HOME/.netrc
fi

echo "Boot detection mail... "$(date)
$HOME/bin/bootmail.py

# Additional scripts to be executed on the first boot after install.
# This makes the `raspbian-ua-netinst` installer more uniform and easier
# to maintain regardless of the use.
if [ ! -e $HOME/.firstboot ]; then
  echo -n "First boot detected on "
  date

  # 1. Update the system
  echo "Updating..."
  sudo apt-get update

  # 2. Install server specific-packages
  echo "Additional packages installation..."
  if [ -e ./$CLNT/add-packages.sh ]; then
    source ./$CLNT/add-packages.sh
  fi

  # 3. Install server specific configuration files
  echo "Copy configuration files..."
  for f in ./$CLNT/config/*; do
    g=$(echo $(basename $f) | sed 's/@/\//g')
    echo $f " --> " $g
    # path must already exist for this to work:
    sudo cp $f /$g
  done

  # 3. Modify existing server specific configuration files
  echo "Modify installation..."
  if [ -e ./$CLNT/mod-files.sh ]; then
    source ./$CLNT/mod-files.sh
  fi

  echo "Install lnxdiagd..."
  git clone https://github.com/Mausy5043/lnxdiagd.git $HOME/lnxdiagd
  # set permissions
  chmod -R 0755 $HOME/lnxdiagd
  pushd $HOME/lnxdiagd
    ./install.sh
  popd

  # Plant the flag and wrap up
  if [ -e /bin/journalctl ]; then
    sudo usermod -a -G systemd-journal $ME
  fi
  touch $HOME/.firstboot

  # The next line is used to run a test on the hardware RNG.
  # date; sudo cat /dev/random | rngtest -c 5000 | logger -t rngtest; date
  # The next line is used to run a speedtest of openSSL.
  # date; openssl speed | logger -t openssl-speed; date

  sudo shutdown -r +1 "First boot installation completed. Please log off now."
  echo -n "First boot installation completed on "
  date
fi
