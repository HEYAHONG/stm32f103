#!/bin/bash
if [  `whoami` != "root" ] 
then
echo Please run as root
exit 255
fi

echo Install gcc
apt-get install gcc-arm-none-eabi -y
echo Install stm32flash
apt-get install  gcc g++ pkg-config make  libncurses5-dev build-essential -y
make -C `pwd`/toolchain/stm32flash/
make -C `pwd`/toolchain/stm32flash/ install
make -C `pwd`/toolchain/stm32flash/ clean
