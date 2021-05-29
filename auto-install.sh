#!/bin/sh


echo -e "\e[31mVérifie d'être bien connecter en root !\e[0m"
sleep 5
echo -e "\e[36mOn vérifie les mises a jour et supprime les packet innutiles\e[0m"
sleep 3
apt update
apt upgrade
apt autoremove
echo -e "\e[36mOn installe les dépendance\e[0m"

apt install xz-utils
apt install git
apt install wget
apt install cat

echo -e "\e[36mOn installe mysql, apache2, phpmyadmin\e[0m"
sleep 3
apt install mariadb-server
mysql_secure_installation
apt install apache2
apt install phpmyadmin

echo -e "\e[36mOn créer l'utilisateur utilisé pour lancer le serveur\e[0m"
sleep 3
adduser fivem

echo -e "\e[36mOn installe l'artefact et on le décompresse\e[0m"


read -p "Mettez le lien de l'artefact [https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/] : " NAME

cd /home/fivem/
wget $NAME
tar xfv fx.tar.xz
rm fx.tar.xz

echo -e "\e[36mOn installe les resources\e[0m"
sleep 3

git clone https://github.com/citizenfx/cfx-server-data.git server-data

echo -e "\e[36mOn installe le server.cfg\e[0m"
sleep 3

read -p "Mettez votre clé de license [https://keymaster.fivem.net/] : " LICENSEKEY
read -p "Mettez votre clé steam Web API [https://steamcommunity.com/dev/apikey] : " APIKEY
read -p "Mettez le nom du serveur : " NAMESRV

cat <<EOT > /home/fivem/server-data/server.cfg
# Only change the IP if you're using a server with multiple network interfaces, otherwise change the port only.
endpoint_add_tcp "0.0.0.0:30120"
endpoint_add_udp "0.0.0.0:30120"

# These resources will start by default.
ensure mapmanager
ensure chat
ensure spawnmanager
ensure sessionmanager
ensure basic-gamemode
ensure hardcap
ensure rconlog

# This allows players to use scripthook-based plugins such as the legacy Lambda Menu.
# Set this to 1 to allow scripthook. Do note that this does _not_ guarantee players won't be able to use external plugins.
sv_scriptHookAllowed 0

# Uncomment this and set a password to enable RCON. Make sure to change the password - it should look like rcon_password "YOURPASSWORD"
#rcon_password ""

# A comma-separated list of tags for your server.
# For example:
# - sets tags "drifting, cars, racing"
# Or:
# - sets tags "roleplay, military, tanks"
sets tags "default"

# A valid locale identifier for your server's primary language.
# For example "en-US", "fr-CA", "nl-NL", "de-DE", "en-GB", "pt-BR"
sets locale "root-AQ" 
# please DO replace root-AQ on the line ABOVE with a real language! :)

# Set an optional server info and connecting banner image url.
# Size doesn't matter, any banner sized image will be fine.
#sets banner_detail "https://url.to/image.png"
#sets banner_connecting "https://url.to/image.png"

# Set your server's hostname
sv_hostname "$NAMESRV"

# Set your server's Project Name
sets sv_projectName "My FXServer Project"

# Set your server's Project Description
sets sv_projectDesc "Default FXServer requiring configuration"

# Nested configs!
#exec server_internal.cfg

# Loading a server icon (96x96 PNG file)
#load_server_icon myLogo.png

# convars which can be used in scripts
set temp_convar "hey world!"

# Remove the `#` from the below line if you do not want your server to be listed in the server browser.
# Do not edit it if you *do* want your server listed.
#sv_master1 ""

# Add system admins
add_ace group.admin command allow # allow all commands
add_ace group.admin command.quit deny # but don't allow quit
add_principal identifier.fivem:1 group.admin # add the admin to the group

# enable OneSync (required for server-side state awareness)
set onesync on

# Server player slot limit (see https://fivem.net/server-hosting for limits)
sv_maxclients 48

# Steam Web API key, if you want to use Steam authentication (https://steamcommunity.com/dev/apikey)
# -> replace "" with the key
set steam_webApiKey $APIKEY

# License key for your server (https://keymaster.fivem.net)
sv_licenseKey $LICENSEKEY

# Merci d'utiliser le script d'installation automatique de serveur FiveM !
# Par Jujugin
# https://github.com/Jujugin/fivem-auto-install

# Thanks for using the automatic installer !
# By Jujugin  
# https://github.com/Jujugin/fivem-auto-install

EOT

echo -e "\e[92mOn a finis d'écrire !\e[0m"

echo -e "\e[36mOn lance le serveur\e[0m"
sleep 3

cd /home/fivem/server-data/
bash ../run.sh +exec server.cfg


#cd /server-data/




