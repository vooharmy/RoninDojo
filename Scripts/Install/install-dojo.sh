#!/bin/bash
# shellcheck source=/dev/null

. "$HOME"/RoninDojo/Scripts/defaults.sh
. "$HOME"/RoninDojo/Scripts/functions.sh

# start of warning
echo -e "${RED}"
echo "***"
echo "Running Dojo install in 15s..."
echo "***"
echo -e "${NC}"
_sleep 5

echo -e "${RED}"
echo "***"
echo "If you have already installed Dojo on your system, use Ctrl+C to exit now!"
echo "***"
echo -e "${NC}"
_sleep 5

echo -e "${RED}"
echo "***"
echo "If you are a new user sit back, relax, and enjoy."
echo "***"
echo -e "${NC}"
_sleep 5
# end of warning

# start dojo setup
echo -e "${RED}"
echo "***"
echo "Downloading and extracting latest RoninDojo release..."
echo "***"
echo -e "${NC}"
cd "$HOME" || exit
git clone "$SAMOURAI_REPO" dojo # CHANGE TO MASTER AFTER MERGE

echo -e "${RED}"
echo "***"
echo "Setting the RPC User and Password..."
echo "***"
echo -e "${NC}"
_sleep 2

echo -e "${RED}"
echo "***"
echo "NOTICE:"
echo "Randomly generated 32 character value is used, and can be found in Dojo conf directory"
echo "located at ${DOJO_PATH}/conf/docker-bitcoind.conf.tpl"
echo "***"
echo -e "${NC}"
_sleep 3

# Create new docker bitcoind conf file

cat << EOF > "${DOJO_PATH}"/conf/docker-bitcoind.conf.tpl
#########################################
# CONFIGURATION OF BITCOIND CONTAINER
#########################################
# User account used for rpc access to bitcoind
# Type: alphanumeric
BITCOIND_RPC_USER=RoninDojo
# Password of user account used for rpc access to bitcoind
# Type: alphanumeric
BITCOIND_RPC_PASSWORD=$RPC_PASS
# Max number of connections to network peers
# Type: integer
BITCOIND_MAX_CONNECTIONS=16
# Mempool maximum size in MB
# Type: integer
BITCOIND_MAX_MEMPOOL=400
# Db cache size in MB
# Type: integer
BITCOIND_DB_CACHE=700
# Number of threads to service RPC calls
# Type: integer
BITCOIND_RPC_THREADS=6
# Mempool expiry in hours
# Defines how long transactions stay in your local mempool before expiring
# Type: integer
BITCOIND_MEMPOOL_EXPIRY=72
# Min relay tx fee in BTC
# Type: numeric
BITCOIND_MIN_RELAY_TX_FEE=0.00001
#
# EXPERT SETTINGS
#
#
# EPHEMERAL ONION ADDRESS FOR BITCOIND
# THIS PARAMETER HAS NO EFFECT IF BITCOIND_INSTALL IS SET TO OFF
#
# Generate a new onion address for bitcoind when Dojo is launched
# Activation of this option is recommended for improved privacy.
# Values: on | off
BITCOIND_EPHEMERAL_HS=on
#
# EXPOSE BITCOIND RPC API AND ZMQ NOTIFICATIONS TO EXTERNAL APPS
# THESE PARAMETERS HAVE NO EFFECT IF BITCOIND_INSTALL IS SET TO OFF
#
# Expose the RPC API to external apps
# Warning: Do not expose your RPC API to internet!
# See BITCOIND_RPC_EXTERNAL_IP
# Value: on | off
BITCOIND_RPC_EXTERNAL=on
# IP address used to expose the RPC API to external apps
# This parameter is inactive if BITCOIND_RPC_EXTERNAL isn't set to 'on'
# Warning: Do not expose your RPC API to internet!
# Recommended value:
#   linux: 127.0.0.1
#   macos or windows: IP address of the VM running the docker host
# Type: string
BITCOIND_RPC_EXTERNAL_IP=127.0.0.1
#
# INSTALL AND RUN BITCOIND INSIDE DOCKER
#
# Install and run bitcoind inside Docker
# Set this option to 'off' for using a bitcoind hosted outside of Docker (not recommended)
# Value: on | off
BITCOIND_INSTALL=on
# IP address of bitcoind used by Dojo
# Set value to 172.28.1.5 if BITCOIND_INSTALL is set to 'on'
# Type: string
BITCOIND_IP=172.28.1.5
# Port of the RPC API
# Set value to 28256 if BITCOIND_INSTALL is set to 'on'
# Type: integer
BITCOIND_RPC_PORT=28256
# Port exposing ZMQ notifications for raw transactions
# Set value to 9501 if BITCOIND_INSTALL is set to 'on'
# Type: integer
BITCOIND_ZMQ_RAWTXS=9501
# Port exposing ZMQ notifications for block hashes
# Set value to 9502 if BITCOIND_INSTALL is set to 'on'
# Type: integer
BITCOIND_ZMQ_BLK_HASH=9502
EOF
# Create new docker bitcoind conf file

# configuring ${DOJO_PATH}/docker/my-dojo/conf/docker-node.conf.tpl
echo -e "${RED}"
echo "***"
echo "Setting the Node API Key and JWT Secret..."
echo "***"
echo -e "${NC}"
_sleep 2

echo -e "${RED}"
echo "***"
echo "NOTICE:"
echo "Randomly generated 64 character value is used, and can be found in Dojo conf directory."
echo "***"
_sleep 2
echo -e "${NC}"

echo -e "${RED}"
echo "***"
echo "Setting the Node Admin Key..."
echo "***"
echo -e "${NC}"
_sleep 2

echo -e "${RED}"
echo "****"
echo "The Node Admin Key is password used to enter the Dojo Maintenance Tool."
echo "***"
_sleep 3
echo -e "${NC}"

echo -e "${RED}"
echo "***"
echo "NOTICE:"
echo "See randomly generated 32 character password in Dojo Menu by using Tor Hidden Service Address option."
echo "***"
echo -e "${NC}"
_sleep 5

cat << EOF > "${DOJO_PATH}"/conf/docker-node.conf.tpl
#########################################
# CONFIGURATION OF NODE JS CONTAINER
#########################################
# API key required for accessing the services provided by the server
# Keep this API key secret!
# Provide a value with a high entropy!
# Type: alphanumeric
NODE_API_KEY=$NODE_API_KEY

# API key required for accessing the admin/maintenance services provided by the server
# Keep this Admin key secret!
# Provide a value with a high entropy!
# Type: alphanumeric
NODE_ADMIN_KEY=$NODE_ADMIN_KEY

# Secret used by the server for signing Json Web Token
# Keep this value secret!
# Provide a value with a high entropy!
# Type: alphanumeric
NODE_JWT_SECRET=$NODE_JWT_SECRET

# Indexer or third-party service used for imports and rescans of addresses
# Values: local_bitcoind | third_party_explorer
NODE_ACTIVE_INDEXER=local_bitcoind

# FEE TYPE USED FOR FEES ESTIMATIONS BY BITCOIND
# Allowed values are ECONOMICAL or CONSERVATIVE
NODE_FEE_TYPE=ECONOMICAL
EOF
# Create new docker node conf file

cat << EOF > "${DOJO_PATH}"/conf/docker-mysql.conf.tpl
#########################################
# CONFIGURATION OF MYSQL CONTAINER
#########################################
# Password of MySql root account
# Type: alphanumeric
MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD
# User account used for db access
# Type: alphanumeric
MYSQL_USER=$MYSQL_USER
# Password of of user account
# Type: alphanumeric
MYSQL_PASSWORD=$MYSQL_PASSWORD
EOF
# Create new mysql conf file

# BTC-EXPLORER PASSWORD
echo -e "${RED}"
echo "***"
echo "Installing your Dojo-backed Bitcoin Explorer..."
echo "***"
echo -e "${NC}"
_sleep

echo -e "${RED}"
echo "***"
echo "This is a fully functioning Bitcoin Blockchain Explorer in a Web Browser."
echo "***"
echo -e "${NC}"
_sleep 3

echo -e "${RED}"
echo "***"
echo "NOTICE:"
echo "See randomly generated 16 character password in Dojo Menu by using Tor Hidden Service Address option."
echo "***"
echo -e "${NC}"
_sleep 5

cat << EOF > "${DOJO_PATH}"/conf/docker-explorer.conf.tpl
#########################################
# CONFIGURATION OF EXPLORER CONTAINER
#########################################
# Install and run a block explorer inside Dojo (recommended)
# Value: on | off
EXPLORER_INSTALL=on
# Password required for accessing the block explorer
# (login can be anything)
# Keep this password secret!
# Provide a value with a high entropy!
# Type: alphanumeric
EXPLORER_KEY=$EXPLORER_KEY
EOF
# create new block explorer conf file

read -rp "Do you want to install an indexer? [y/n]" yn
case $yn in
    [Y/y]* )
      sudo sed -i 's/INDEXER_INSTALL=off/INDEXER_INSTALL=on/' "${DOJO_PATH}"/conf/docker-indexer.conf.tpl
      sudo sed -i 's/NODE_ACTIVE_INDEXER=local_bitcoind/NODE_ACTIVE_INDEXER=local_indexer/' "${DOJO_PATH}"/conf/docker-node.conf.tpl
      ;;
    [N/n]* ) echo "Indexer will not be installed!";;
    * ) echo "Please answer Yes or No.";;
esac
# install indexer

read -rp "Do you want to install Electrs? [y/n]" yn
case $yn in
    [Y/y]* ) bash ~/RoninDojo/Scripts/Install/install-electrs-indexer.sh;;
    [N/n]* ) echo "Electrs will not be installed!";;
    * ) echo "Please answer Yes or No.";;
esac
# install electrs

echo -e "${RED}"
echo "***"
echo "See documentation at https://code.samourai.io/ronindojo/RoninDojo/-/wikis/home"
echo "***"
echo -e "${NC}"
_sleep 5
# end dojo setup

echo -e "${RED}"
echo "***"
echo "Installing Dojo..."
echo "***"
echo -e "${NC}"
_sleep 2

cd "$DOJO_PATH" || exit

./dojo.sh install
# once dojo install reaches bitcoind logs / begins syncing then use Ctrl + C to exit and trigger the salvage attempt below

if sudo test -d /mnt/usb/uninstall-salvage; then
  echo -e "${RED}"
  echo "***"
  echo "Blockchain data salvage starting..."
  echo "***"
  echo -e "${NC}"
  sleep 2s

  echo -e "${RED}"
  echo "***"
  echo "Press any letter to continue..."
  echo "***"
  echo -e "${NC}"
  read -n 1 -r -s
  # press to continue is needed because sudo password can be requested for next steps, if user is AFK there may be timeout
  cd "$DOJO_PATH" || exit

  ./dojo.sh stop
  sudo rm -rf /mnt/usb/docker/volumes/my-dojo_data-bitcoind/_data/{blocks,chainstate}
  sudo mv -v /mnt/usb/uninstall-salvage/{blocks,chainstate} /mnt/usb/docker/volumes/my-dojo_data-bitcoind/_data/

  echo -e "${RED}"
  echo "***"
  echo "Blockchain data salvage complete!"
  echo "***"
  echo -e "${NC}"
  sleep 3s
  sudo rm -rf /mnt/usb/{system-setup-salvage,uninstall-salvage}

  cd "$DOJO_PATH" && ./dojo.sh start
else
  echo "No Blockchain data found for salvage check 1..."
fi
# check for uninstall-salvage, if not found continue

if sudo test -d /mnt/usb/system-setup-salvage; then
  echo -e "${RED}"
  echo "***"
  echo "Blockchain data salvage starting..."
  echo "***"
  echo -e "${NC}"
  sleep 2s

  echo -e "${RED}"
  echo "***"
  echo "Press any letter to continue..."
  echo "***"
  echo -e "${NC}"
  read -n 1 -r -s
  cd "$DOJO_PATH" || exit

  ./dojo.sh stop
  sudo rm -rf /mnt/usb/docker/volumes/my-dojo_data-bitcoind/_data/{blocks,chainstate}
  sudo mv -v /mnt/usb/system-setup-salvage/{blocks,chainstate} /mnt/usb/docker/volumes/my-dojo_data-bitcoind/_data/

  echo -e "${RED}"
  echo "***"
  echo "Blockchain data salvage complete!"
  echo "***"
  echo -e "${NC}"
  sleep 3s
  sudo rm -rf /mnt/usb/{system-setup-salvage,uninstall-salvage}
  cd "$DOJO_PATH" || exit

  ./dojo.sh start
else
  echo "No Blockchain data found for salvage check 2..."
fi
# check for system-setup-salvage, if not found continue
