#!/bin/bash


DIRS3="s3bucket-jenkins-backup" 
BACKUP_FILE="jenkins-backup.tar.gz"
BACKUP_OLD="jenkins-backup.tar.gz.old"
DIR="backup"

echo
echo " *** Jenkins restore is running ... *** "
echo

if [ ! -d  "$DIR" ];  
then  
echo "Creating  folder  -> backup" 
mkdir -p $DIR 
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

# sudo usermod -aG docker $USER 
rm -rf ../var/jenkins_home/*
cp -R jenkins_home/*  ../var/jenkins_home/
cd ..
rm -rf backup

echo
echo "*** Restore complete ***"
echo