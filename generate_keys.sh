#!/bin/sh

# Create the ssh-key we will use for the frontend node
mkdir -p sshkeys
rm -fr sshkeys/*
ssh-keygen -t rsa -b 4096 -C "opennebula@frontend" -f sshkeys/id_rsa -q -N ""