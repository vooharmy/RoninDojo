#!/bin/bash

RED='\033[0;31m'
# used for color with ${RED}
NC='\033[0m'
# No Color

### FOR POST INITIAL SETUP TO BE PLACED IN /etc/profile.d/

echo -e "${RED}"
echo "***"
echo "Welcome to Ronin Dojo UI...."
echo -e "${NC}"
sleep 3s

echo -e "${NC}"
echo " _____________________________________________________|_._._._._._._._._, "
echo " \____________________________________________________|_|_|_|_|_|_|_|_|_| "
echo "                                                      !                   "
echo -e "${RED}"
echo " I dreamt of        ______            _          _   _ _                  "
echo "   worldly success  | ___ \          (_)        | | | (_)                 "
echo "               once.| |_/ /___  _ __  _ _ __    | | | |_|                 "
echo "                    |    // _ \| '_ \| | '_ \   | | | | |                 "
echo "                    | |\ \ (_) | | | | | | | |  | |_| | |                 "
echo "                    \_| \_\___/|_| |_|_|_| |_|by\____/|_|                 "
echo "                                              @GuerraMoneta               "
echo -e "                                            & @BTCxZelko          ${NC}"
echo " ,_._._._._._._._._|_____________________________________________________ "
echo " |_|_|_|_|_|_|_|_|_|____________________________________________________/ "
echo "                   !                                                      "
echo -e "${NC}"
sleep 10s

cp ~/RoninDojo/Scripts/.dialogrc ~/.dialogrc
# config file for dialog color

HEIGHT=22
WIDTH=76
CHOICE_HEIGHT=16
TITLE="Ronin UI"
MENU="Choose one of the following options:"

OPTIONS=(1 "Dojo Menu"
         2 "Whirlpool Menu"
         3 "Electrs Menu"
         4 "Firewall Menu"
	 5 "System Menu"
         6 "System Setup & Installs")

CHOICE=$(dialog --clear \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
            bash ~/RoninDojo/Scripts/Menu/ronin-dojo-menu.sh
            # runs dojo management menu script
            ;;
        2)
            bash ~/RoninDojo/Scripts/Menu/ronin-whirlpool-menu.sh
            # runs the whirlpool menu script
            ;;
        3)
            bash ~/RoninDojo/Scripts/Menu/ronin-electrs-menu.sh
            # runs electrs menu script
            ;;
        4)
            bash ~/RoninDojo/Scripts/Menu/ronin-firewall-menu.sh
            # runs firewall menu script
            ;;
        5)
            bash ~/RoninDojo/Scripts/Menu/ronin-system-menu.sh
            # runs system menu script
            ;;
        6)
            bash ~/RoninDojo/Scripts/Menu/ronin-install-menu.sh
	    # runs installs menu
            ;;
esac
