
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
#install_package "samba"
#install_package "samba-common-bin"
#install_package "btrfs-tools"
install_package "f2fs-tools"
install_package "nfs-common"
install_package "apt-utils"
install_package "logrotate"
install_package "raspi-copies-and-fills"
install_package "rsync"
install_package "lsb-release"

install_package "bc"
install_package "dieharder"
install_package "git"
install_package "htop"
install_package "lsof"
install_package "nano"
install_package "psmisc"
install_package "screen"
install_package "stress"
install_package "tree"
install_package "graphviz"
