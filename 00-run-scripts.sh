#! /bin/bash

logfile=/tmp/gitbin.err
CLNT=$(hostname)

# Timestamp the logfile
date

# Change PWD to the binaries directory
pushd /home/pi/gitbin

# Boot detection
if [ ! -e /tmp/gitbin.reboot ]; then
  # Set the flag first to prevent recursive execution
  whoami > /tmp/gitbin.reboot
  ( ./01-post-boot.sh 2>&1 | tee -a ../post-boot.log | logger -p local7.info -t 01-post-boot ) &
fi

# Check for new/updated scripts
./02-update-scripts.sh
# Execute the common scripts in parallel
./11-get-temp.py & ./12-get-load.py & ./13-get-nettraffic.py & ./14-get-memory.py & ./15-get-logstate.py & wait

# Execute client-specific scripts
case "$CLNT" in
  rbups )   echo "UPS monitor"
            ./16-get-upsstate.py
            ;;
  rbelec )  echo "Electricity monitor"
            ./17-get-electra.py
            ;;
  rbian )   echo "Raspberry testbench"
            # ./testserial.py &
            ;;
  * )       echo "!! undefined client !!"
            ;;
esac

# Create the XML-file last
./31-xml-status.sh
# Upload the data
./99-upload-data.sh
