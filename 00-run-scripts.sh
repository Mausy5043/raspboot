#! /bin/bash

CLNT=$(hostname)
ME=$(whoami)

# Timestamp the logfile
date

# Change PWD to the binaries directory
pushd $HOME/raspboot
  ./02-update-scripts.sh
  # Boot detection
  if [ ! -e /tmp/raspboot.reboot ]; then
    # Set the flag first to prevent recursive execution
    whoami > /tmp/raspboot.reboot
    git config core.fileMode false
    ( ./01-post-boot.sh 2>&1 | tee -a ../post-boot.log | logger -p local7.info -t 01-post-boot ) &
  fi

  # Execute client-specific scripts
  case "$CLNT" in
    rbagain ) echo "Weather monitor"
              sudo pigpiod
              ;;
    rbups )   echo "UPS monitor"
              ;;
    rbelec )  echo "Electricity monitor"
              ;;
    rbian )   echo "Raspberry testbench"
              ;;
    osmc )    echo "OSMC Media Center"
              ;;
    * )       echo "!! undefined client !!"
              ;;
  esac

  date
popd
