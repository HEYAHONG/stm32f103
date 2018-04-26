#!/bin/bash
if [  `whoami` != "root" ] 
then
echo Please run as root
exit 255
fi

echo Install gcc
apt-get install gcc-arm-none-eabi -y
