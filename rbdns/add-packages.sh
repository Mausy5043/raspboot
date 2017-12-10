
install_package()
{
  # See if packages are installed and install them.
  package=$1
  echo "*********************************************************"
  echo "* Requesting $package"
  status=$(dpkg-query -W -f='${Status} ${Version}\n' $package 2>/dev/null | wc -l)
  if [ "$status" -eq 0 ]; then
    echo "* Installing $package"
    echo "*********************************************************"
    sudo apt-get -yuV install $package
  else
    echo "* Already installed !!!"
    echo "*********************************************************"
  fi
}

echo "Installing additional packages..."
install_package "graphviz"
install_package "nmap"
install_package "tcpdump"
install_package "traceroute"
install_package "pcaputils"
install_package "dnsutils"
install_package "iproute2"
install_package "iputils-arping"
install_package "dnsmasq"

echo "MANUALLY INSTALL PACKAGE: tshark"
