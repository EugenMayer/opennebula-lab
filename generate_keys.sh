#!/bin/sh

mkdir -p sshkeys
ssh-keygen -b 2048 -t rsa -f sshkeys/id_rsa -q -N ""