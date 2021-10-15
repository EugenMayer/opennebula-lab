#!/bin/sh

sudo ssh-keygen -b 2048 -t rsa -f /tmp/sshkey -q -N ""

wget 'https://github.com/OpenNebula/minione/releases/latest/download/minione'
sudo bash minione --marketapp-name 'Debian 10' --frontend --force --yes


onehost create compute1 --im qemu --vm qemu