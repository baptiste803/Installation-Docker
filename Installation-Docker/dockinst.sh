#!/bin/bash

# Uncomment set -x to execute the script
# set -x

# The section below use to catch the ubuntu version for the source file
declare ubuntu_version
ubuntu_version=$(lsb_release -cs)

# The section below is a function to print the download progress, this 
# function is used at every statement
chargement() {
	clear
	if(( charge == 100 )); then
		echo -e "\rTéléchargement ${charge}%"
		exit
	fi
	charge=$((charge + RANDOM % 12))
	echo -e "\rTéléchargement ${charge}%"
}

# This section used to find the configuration files for the docker 
# installation and erase them in case of re-installation
if [ -e /etc/apt/keyrings/docker.asc ]; then
	rm -rf /etc/apt/keyrings/docker.asc
fi
if [ -e /etc/apt/sources.list.d/docker.sources ]; then
	rm -rf /etc/apt/sources.list.d/docker.sources
fi

chargement # download progress statement

# update apt package before installation
apt update -y 1>/dev/null 2>/dev/null
apt upgrade -y 1> /dev/null 2>/dev/null

chargement # download progress statement

# ca-certificates installation
apt install ca-certificates -y 2>/dev/null 1>/dev/null

chargement	# download progress statement

# GPG access key download command and file creation
wget https://download.docker.com/linux/debian/gpg -O /etc/apt/keyrings/docker.asc 1>/dev/null 2>/dev/null
chmod a+r /etc/apt/keyrings/docker.asc

chargement 	# download progress statement

# Command use to create the source file to add in the apt librairy 
# the access of the docker engine api. There you can find the path of the 
# source file, the online path where the API is available and the key
# who auhtorize the package to be download
tee /etc/apt/sources.list.d/docker.sources 1>/dev/null 2>/dev/null <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: ${ubuntu_version}
Components: stable
Signed-by: /etc/apt/keyrings/docker.asc
EOF

chargement	# download progress statement

# The source file is created, the apt repository used to be updated to access 
# to the docker engine API
apt update -y 1>/dev/null 2>/dev/null
apt upgrade -y 1>/dev/null 2>/dev/null

# There it is the docker API package has been added to the apr repository
# now it is time to download each package :
apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y 1>/dev/null 2>/dev/null

charge=100

chargement
