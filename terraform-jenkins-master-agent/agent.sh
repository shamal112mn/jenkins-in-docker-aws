#!/bin/bash

sudo apt-get update 
# install java jdk11 
sudo apt-get install openjdk-11-jdk -y
# install maven
sudo apt-get install maven -y
# install eksctl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
# install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl


cd 
git clone https://github.com/shamal112mn/jenkins-in-docker-aws.git

if [ ! -d  "~/.ssh" ]; 
    then mkdir ~/.ssh 
fi

cat ~/jenkins-in-docker-aws/extra_key.pub  >> ~/.ssh/authorized_keys
 

echo " *All commands executed successfuly!* "
