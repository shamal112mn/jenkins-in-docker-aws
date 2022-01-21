#!/bin/bash

DIR="/home/ubuntu/jenkins-in-docker-aws"
SSH="/home/ubuntu/.ssh"
 
docker run -d --name myjenkins -v jenkins_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock -p 8080:8080 -p 50000:50000 jenkins/jenkins:lts-jdk11
sleep 5
cd 
git clone https://github.com/shamal112mn/jenkins-in-docker-aws.git
 
mkdir ~/.ssh
cp $DIR/extra_key  $SSH/id_rsa
chmod 400 $SSH/id_rsa
cp $DIR/extra_key.pub  $SSH/id_rsa.pub
chmod 644 $SSH/id_rsa.pub
source  $DIR/restore.sh
 
echo "#########   all commands executed successfuly !! ########## "
 