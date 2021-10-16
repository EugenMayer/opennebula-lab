#!/bin/sh
set -e

sudo apt-get update
sudo apt-get install -y gnupg curl wget apt-transport-https

sudo -- sh -c 'echo "deb https://downloads.opennebula.io/repo/6.1/Debian/11 stable opennebula" > /etc/apt/sources.list.d/opennebula.list'
sudo -- sh -c 'wget -q -O- https://downloads.opennebula.io/repo/repo.key | apt-key add -'
sudo apt-get update
sudo apt-get install -y opennebula-node-kvm 