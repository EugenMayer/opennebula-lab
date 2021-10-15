#!/bin/sh

sudo ssh-keygen -b 2048 -t rsa -f /tmp/sshkey -q -N ""
sudo apt-get update
sudo apt-get install -y qemu qemu-kvm