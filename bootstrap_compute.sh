#!/bin/sh

sudo ssh-keygen -b 2048 -t rsa -f /tmp/sshkey -q -N ""
sudo apt-get update

# rsync is used to copy files from frontend to compute during INIT 
sudo apt-get install -y rysnc
sudo apt-get install -y qemu qemu-kvm