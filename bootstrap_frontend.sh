#!/bin/sh
set -e

sudo apt-get update
sudo apt-get install -y gnupg curl wget apt-transport-https

# see https://github.com/OpenNebula/minione
#curl -Lq -o minione 'https://github.com/OpenNebula/minione/releases/latest/download/minione'
curl -Lq -o minione 'https://raw.githubusercontent.com/OpenNebula/minione/master/minione'
sudo bash minione --marketapp-name 'Debian 11' --frontend --force --yes --version 6.1
#sudo -- sh -c "echo 'oneadmin:oneadmin' > /var/lib/one/.one/one_auth"