#!/bin/bash


apt-get update
apt install docker.io -y 
usermod -aG docker ubuntu
apt install python3-pip -y
pip3 install awscli
apt install -y wget curl unzip

echo " *USERDATA commands executed successfuly!* "
 