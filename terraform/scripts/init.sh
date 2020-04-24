#!/bin/bash

# Install mandatory packages before setting up system.

dnf makecache
dnf -y install epel-release
declare -a Package=("ansible" "wget" "git" "unzip" "zip" "curl")
for val in "${Package[@]}"; do 
    dnf -y install $val
done

dnf -y update

ansible-playbook --connection=local 127.0.0.1 main.yaml