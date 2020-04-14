#!/bin/bash

RED=$(tput setaf 1)
# used for color with ${RED}
NC=$(tput sgr0)
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
