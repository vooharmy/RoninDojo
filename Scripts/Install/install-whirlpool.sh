#!/bin/bash

RED='\033[0;31m'
# used for color with ${RED}
NC='\033[0m'
# No Color

echo -e "${RED}"
echo "***"
echo "Checking if Whirlpool is already installed..."
echo "***"
echo -e "${NC}"

if ls ~/whirlpool | grep whirlpool.jar  > /dev/null ; then
    echo -e "${RED}"
    echo "***"
    echo "Whirlpool is installed!"
    echo "***"
    echo -e "${NC}"
    sleep 2s

    echo "***"
    echo "Returning to Menu..."
    echo "***"
    echo -e "${NC}"
    sleep 2s
    bash ~/RoninDojo/Scripts/Menu/menu-whirlpool.sh
    exit
fi
# checks if whirlpool.jar exists, if so kick back to menu

echo -e "${RED}"
echo "***"
echo "Checking if Tor is installed..."
echo "***"
echo -e "${NC}"

torcheck=/usr/bin/tor
if pacman -Ql | grep $torcheck  > /dev/null ; then
    echo -e "${RED}"
    echo "***"
    echo "The package $package is installed."
    echo "***"
    echo -e "${NC}"
else
    echo -e "${RED}"
    echo "***"
    echo "The package $package will be installed now."
    echo "***"
    echo -e "${NC}"
    sudo pacman -S --noconfirm tor
    sleep 1s
    sudo sed -i '52d' /etc/tor/torrc
    sudo sed -i '52i DataDirectory /mnt/usb/tor' /etc/tor/torrc
    sudo sed -i '56d' /etc/tor/torrc
    sudo sed -i '56i ControlPort 9051' /etc/tor/torrc
    sudo sed -i '60d' /etc/tor/torrc
    sudo sed -i '60i CookieAuthentication 1' /etc/tor/torrc
    sudo sed -i '61i CookieAuthFileGroupReadable 1' /etc/tor/torrc
    sudo mkdir /mnt/usb/tor/
    sudo chown -R tor:tor /mnt/usb/tor/
fi
# check if tor is installed, if not install and modify torrc

echo -e "${RED}"
echo "***"
echo "Installing Whirlpool..."
echo "***"
echo -e "${NC}"
sleep 3s

echo -e "${RED}"
echo "***"
echo "A UFW rule will be made for Whirlpool..."
echo "***"
echo -e "${NC}"
sleep 2s

echo -e "${RED}"
echo "***"
echo "Whirlpool GUI will be able to access Whirlpool CLI from any machine on your RoninDojo's local network."
echo "***"
echo -e "${NC}"
sleep 5s

if sudo ufw status | grep 8899 > /dev/null ; then
    echo -e "${RED}"
    echo "***"
    echo "Whirlpool firewall rule already setup..."
    echo "***"
    echo -e "${NC}"
    sleep 1s
else
    ip addr | sed -rn '/state UP/{n;n;s:^ *[^ ]* *([^ ]*).*:\1:;s:[^.]*$:0/24:p}' > ~/ip_tmp.txt
    # creates ip_tmp.txt with IP address listed in ip addr, and makes ending .0/24

    sed -i '2,12d' ~/ip_tmp.txt
    # delete lines 2-12 (in the systemsetup script it is 2,10d
    # had to be modified for whirlpool setup as an extra value gets added to ~/ip_tmp.txt)

    cat ~/ip_tmp.txt | while read ip ; do echo "### tuple ### allow any 8899 0.0.0.0/0 any ""$ip" > ~/whirlpool_rule_tmp.txt; done
    # pipes output from ip_tmp.txt into read, then uses echo to make next text file with needed changes plus the ip address
    # for line 19 in /etc/ufw/user.rules

    cat ~/ip_tmp.txt | while read ip ; do echo "-A ufw-user-input -p tcp --dport 8899 -s "$ip" -j ACCEPT" >> ~/whirlpool_rule_tmp.txt; done
    # pipes output from ip_tmp.txt into read, then uses echo to make next text file with needed changes plus the ip address
    # for line 20 /etc/ufw/user.rules

    cat ~/ip_tmp.txt | while read ip ; do echo "-A ufw-user-input -p udp --dport 8899 -s "$ip" -j ACCEPT" >> ~/whirlpool_rule_tmp.txt; done
    # pipes output from ip_tmp.txt into read, then uses echo to make next text file with needed changes plus the ip address
    # for line 21 /etc/ufw/user.rules

     sudo awk 'NR==1{a=$0}NR==FNR{next}FNR==19{print a}1' ~/whirlpool_rule_tmp.txt /etc/ufw/user.rules > ~/user.rules_tmp.txt && sudo mv ~/user.rules_tmp.txt /etc/ufw/user.rules
    # copying from line 1 in whirlpool_rule_tmp.txt to line 19 in /etc/ufw/user.rules
    # using awk to get /lib/ufw/user.rules output, including newly added values, then makes a tmp file
    # after temp file is made it is mv to /lib/ufw/user.rules
    # awk does not have -i to write changes like sed does, that's why I took this approach

     sudo awk 'NR==2{a=$0}NR==FNR{next}FNR==20{print a}1' ~/whirlpool_rule_tmp.txt /etc/ufw/user.rules > ~/user.rules_tmp.txt && sudo mv ~/user.rules_tmp.txt /etc/ufw/user.rules
    # copying from line 2 in whirlpool_rule_tmp.txt to line 20 in /etc/ufw/user.rules

     sudo awk 'NR==3{a=$0}NR==FNR{next}FNR==21{print a}1' ~/whirlpool_rule_tmp.txt /etc/ufw/user.rules > ~/user.rules_tmp.txt && sudo mv ~/user.rules_tmp.txt /etc/ufw/user.rules
    # copying from line 3 in whirlpool_rule_tmp.txt to line 21 in /etc/ufw/user.rules

     sudo sed -i "18G" /etc/ufw/user.rules
    # adds a space to keep things formatted nicely

     sudo chown root:root /etc/ufw/user.rules
    # this command changes ownership back to root:root
    # when /etc/ufw/user.rules is edited using awk or sed, the owner gets changed from Root to whatever User that edited that file
    # that causes a warning to be displayed as /etc/ufw/user.rules does need to be owned by root:root

     sudo rm ~/ip_tmp.txt ~/whirlpool_rule_tmp.txt
    # removes txt files that are no longer needed

    echo -e "${RED}"
    echo "***"
    echo "Reloading UFW..."
    echo "***"
    echo -e "${NC}"
    sleep 1s
    sudo ufw reload
fi
# checks for port 8899 ufw rule and skips if found, if not found it is set up

echo -e "${RED}"
echo "***"
echo "Checking UFW status..."
echo "***"
echo -e "${NC}"
sleep 2s
sudo ufw status

echo -e "${RED}"
echo "***"
echo "Created a Whirlpool directory."
echo "***"
echo -e "${NC}"
sleep 1s
cd $HOME
mkdir whirlpool
cd whirlpool
# create whirlpool directory

echo -e "${RED}"
echo "***"
echo "Pulling Whirlpool from Github..."
echo "***"
echo -e "${NC}"
sleep 1s
wget -O whirlpool.jar https://github.com/Samourai-Wallet/whirlpool-client-cli/releases/download/0.10.4/whirlpool-client-cli-0.10.4-run.jar
# pull Whirlpool run times

USER=$(sudo cat /etc/passwd | grep 1000 | awk -F: '{ print $1}' | cut -c 1-)

# whirlpool service. Check if present else create it
echo -e "${RED}"
echo "***"
echo "Checking if Whirlpool.service is already exists..."
echo "***"
echo -e "${NC}"

if ls /etc/systemd/system | grep whirlpool.service  > /dev/null ; then
    echo -e "${RED}"
    echo "***"
    echo "Whirlpool Service already is installed!"
    echo "***"
    sleep 1s
    sudo systemctl stop whirlpool
else
    echo -e "${RED}"
    echo "***"
    echo "Setting Whirlpool Service..."
    echo "***"
    echo -e "${NC}"
    sleep 1s

    echo "
    [Unit]
    Description=Whirlpool
    After=tor.service

    [Service]
    WorkingDirectory=/home/$USER/whirlpool
    ExecStart=/usr/bin/java -jar /home/$USER/whirlpool/whirlpool.jar --server=mainnet --tor --auto-mix --listen
    User=$USER
    Group=$USER
    Type=simple
    KillMode=process
    TimeoutSec=60
    Restart=always
    RestartSec=60

    [Install]
    WantedBy=multi-user.target
    " | sudo tee -a /etc/systemd/system/whirlpool.service
fi
# checks for whirlpool.service and if found skips, if not found sets up whirlpool.service

sudo systemctl daemon-reload
sleep 3s

echo -e "${RED}"
echo "***"
echo "Starting Whirlpool in the background..."
echo "***"
echo -e "${NC}"
sleep 1s

sudo systemctl start whirlpool
sudo systemctl enable whirlpool
sleep 3s

echo -e "${RED}"
echo "***"
echo "Install Whirlpool GUI to initiate Whirlpool and then unlock wallet to begin mixing..."
echo "***"
echo -e "${NC}"
sleep 3s

echo -e "${RED}"
echo "***"
echo "For pairing with GUI head to full guide at: https://code.samourai.io/ronindojo/RoninDojo/-/wikis/home"
echo "***"
echo -e "${NC}"
sleep 3s

echo -e "${RED}"
echo "***"
echo "Press any letter to continue..."
echo "***"
echo -e "${NC}"
read -n 1 -r -s
# will return to menu as long as [*] Go Back was selected
