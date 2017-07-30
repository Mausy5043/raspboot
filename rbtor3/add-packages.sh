
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

install_package "graphviz"
install_package "samba"
install_package "deluged"
install_package "deluge-console"
install_package "deluge-web"
install_package "smartmontools"
