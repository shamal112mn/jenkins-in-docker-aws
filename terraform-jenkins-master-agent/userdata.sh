#!/bin/bash

dockerState=1

apt-get update
apt install docker.io -y 
while [ ! $dockerState -eq 0 ];
do 
sleep 5 
echo " USERDATA: Waiting for docker to start ... "
docker ps > /dev/null
dockerState="$?"
echo $dockerState
done
usermod -aG docker ubuntu
apt install python3-pip -y
pip3 install awscli
apt install -y wget curl unzip

echo " *USERDATA commands executed successfuly!* "
 