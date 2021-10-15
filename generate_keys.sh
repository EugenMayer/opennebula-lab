#!/bin/sh

mkdir -p sshkeys
rm -fr sshkeys/*
ssh-keygen -t rsa -b 4096 -C "opennebula@frontend" -f sshkeys/id_rsa -q -N ""