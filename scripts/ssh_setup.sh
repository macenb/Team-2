#!/bin/bash

set -e

users=("usersgohere")
# pubkey_file=$1

for i in "${users[@]}"; do
    useradd $i
    mkhomedir_helper $i
    mkdir /home/$i/.ssh
    touch /home/$i/.ssh/authorized_keys
    # cat $1 > /home/$i/authorized_keys
done
