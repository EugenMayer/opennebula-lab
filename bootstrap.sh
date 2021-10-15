#!/bin/sh

wget 'https://github.com/OpenNebula/minione/releases/latest/download/minione'
sudo bash minione --marketapp-name 'Debian 10' --frontend --force --yes
#sudo -- sh -c "echo 'oneadmin:oneadmin' > /var/lib/one/.one/one_auth"