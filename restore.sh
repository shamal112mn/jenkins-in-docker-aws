#!/bin/bash


DIRS3="s3bucket-jenkins-backup" 
BACKUP_FILE="jenkins-backup.tar.gz"
BACKUP_OLD="jenkins-backup.tar.gz.old"
DIR="backup"
DIRV="/var/lib/docker/volumes"
CONTAINER="myjenkins"
 



echo
echo " *** Script is restoring JENKINS_HOME ... *** "
echo

 
echo " Stopping and removing $CONTAINER container ... " 
docker stop $CONTAINER
docker rm $CONTAINER
cd 
if [ ! -d  "~/$DIR" ];  
then  
echo "Creating  folder  -> backup" 
mkdir -p ~/$DIR 
fi 

cd backup
aws s3 sync s3://$DIRS3 .
ll
if [ ! -f "$BACKUP_FILE" ];
then
  if [ -f "$BACKUP_OLD" ];
  then
    mv $BACKUP_OLD  $BACKUP_FILE
    tar xvf $BACKUP_FILE     
  else
    echo "Jenkins Backup files didn't sync from S3 bucket"
    exit 0
  fi
else
  tar xvf $BACKUP_FILE  
fi 

sudo usermod -aG docker $USER 
sudo rm -rf $DIRV/jenkins_home/*
sudo cp -R jenkins_home/*  $DIRV/jenkins_home/
sudo chown -R $USER:$USER  $DIRV/jenkins_home
cd ..
rm -rf backup
docker run -d --name $CONTAINER -v jenkins_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock -p 8080:8080 -p 50000:50000 jenkins/jenkins:lts-jdk11

cd
echo
echo "*** Restore complete ***"
echo
