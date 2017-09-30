
install_package()
{
  # See if packages are installed and install them.
  package=$1
  echo "*********************************************************"
  echo "* Requesting ${package}"
  status=$(dpkg-query -W -f='${Status} ${Version}\n' "${package}" 2>/dev/null | wc -l)
  if [ "${status}" -eq 0 ]; then
    echo "* Installing ${package}"
    echo "*********************************************************"
    sudo apt-get -yuV install "${package}"
  else
    echo "* Already installed !!!"
    echo "*********************************************************"
  fi
}

echo "Installing UPS monitor packages..."
install_package "nut"
install_package "graphviz"

#echo "Installing CUPS packages..."
#sudo apt-get -yuV install cups cifs-utils smb-client
#echo "Pausing... (1/4) "
#sleep 60
#sudo apt-get -yuV install hplip-cups openprinting-ppds
#echo "Pausing... (2/4) "
#sleep 60
#sudo apt-get -yuV install cups-pdf cups-driver-gutenprint
#echo "Pausing... (3/4) "
#sleep 60
#sudo apt-get -yuV install python-cups python-daemon python-pkg-resources
#echo "Pausing... (4/4)"
#sleep 60
