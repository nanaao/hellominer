#!/bin/bash

YUM_CMD=$(which yum)
APT_GET_CMD=$(which apt-get)
if [[ ! -z "$YUM_CMD" ]]; then
    yum install -y iptables ipset
    yum update -y iptables
    yum install -y iptables-services
    systemctl stop firewalld
    systemctl mask firewalld
    systemctl enable iptables.service
    systemctl start iptables.service
elif [[ ! -z "$APT_GET_CMD" ]]; then
    apt install -y iptables ipset
else
  echo "error can't install required package"
  exit 1;
 fi


cd /root
mkdir hellominer
set -e
curl -L -o hellominer.tar.gz https://raw.githubusercontent.com/hellominer/hellominer/main/releases/hellominer.tar.gz
tar zxf hellominer.tar.gz -C /root/hellominer
cd /root/hellominer
./hellominer install
./hellominer start
./hellominer  status
IP=$(curl -s ifconfig.me)
echo "binary installed at /root/hellominer/hellominer"
echo "config path at /etc/hellominer/conf/"
echo "install done, please open the URL to login, http://$IP:51301 , password is: 123456"
