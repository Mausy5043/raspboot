echo "Installing WIFI support..."
sudo apt-get -yuV install wavemon usbutils

echo "Installing additional packages..."
sudo apt-get -yuV install build-essential python-dev python-setuptools python-rpi.gpio
sudo apt-get -yuV install wiringpi
gpio readall

sudo apt-get -yuV install gnuplot gnuplot-nox mysql-client python-mysqldb

sudo apt-get -yuV install rpi-update avahi-daemon