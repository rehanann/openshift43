#!/bin/bash

# Install mandatory packages before setting up system.

declare -a Package=("ansible" "wget" "git" "unzip" "zip" "curl")
for val in $Package[@]; do 
    yum -y install $val
done


ansible-playbook --connection=local 127.0.0.1 main.yaml