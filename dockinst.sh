#!/bin/bash

#set -x

chargement() {
	clear
	if(( charge == 100 )); then
		echo -e "\rTéléchargement ${charge}%"
		exit
	fi
	charge=$((charge + RANDOM % 12))
	echo -e "\rTéléchargement ${charge}%"
}

if [ -e /etc/apt/keyrings/docker.asc ]; then
	rm -rf /etc/apt/keyrings/docker.asc
elif [ -e /etc/apt/sources.list.d/docker.sources ]; then
	rm -rf /etc/apt/sources.list.d/docker.sources
fi

chargement

apt update -y 1>/dev/null 2>/dev/null
apt upgrade -y 1> /dev/null 2>/dev/null

chargement

apt install ca-certificates -y 2>/dev/null 1>/dev/null

chargement

wget https://download.docker.com/linux/debian/gpg -O /etc/apt/keyrings/docker.asc 1>/dev/null 2>/dev/null
chmod a+r /etc/apt/keyrings/docker.asc

chargement

tee /etc/apt/sources.list.d/docker.sources 1>/dev/null 2>/dev/null <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: noble
Components: stable
Signed-by: /etc/apt/keyrings/docker.asc
EOF

chargement

apt update -y 1>/dev/null 2>/dev/null
apt upgrade -y 1>/dev/null 2>/dev/null
apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y 1>/dev/null 2>/dev/null

charge=100

chargement
