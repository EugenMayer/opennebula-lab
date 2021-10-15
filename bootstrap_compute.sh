#!/bin/sh

sudo apt-get update
sudo apt-get install gnupg wget apt-transport-https

sudo -- sh -c 'echo "deb https://downloads.opennebula.io/repo/6.0/Debian/10 stable opennebula" > /etc/apt/sources.list.d/opennebula.list'
sudo -- sh -c 'wget -q -O- https://downloads.opennebula.io/repo/repo.key | apt-key add -'
sudo apt-get update
sudo apt-get install opennebula-node-kvm -y