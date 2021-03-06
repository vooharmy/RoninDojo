#!/bin/bash

RED='\033[0;31m'
# used for color with ${RED}
NC='\033[0m'
# No Color

echo -e "${RED}"
echo "***"
echo "Installing Whirlpool Stat Tool..."
echo "***"
echo -e "${NC}"
mkdir ~/wst;
cd ~/wst;
git clone https://github.com/Samourai-Wallet/whirlpool_stats.git;
sudo pacman -Syyu;
sudo pacman -S python-pip;
cd whirlpool_stats;
sudo pip3 install -r ./requirements.txt;
bash ~/RoninDojo/Scripts/Menu/menu-whirlpool-wst.sh
