#!/bin/bash

# Script to rsync on new location -> archive and zip  -> move to aws S3  
# rsync jenkins_home -> /data/jenkins_home   from 

DIRS3="s3bucket-jenkins-backup" 
BACKUP_FILE="jenkins-backup.tar.gz"
BACKUP_OLD="jenkins-backup.tar.gz.old"
DIR="backup/jenkins_home"

echo
echo "*** Running Jenkins backup ... ***"
echo 
if [ ! -d  "~/$DIR" ];  
then  
echo "Creating  folder  -> backup/jenkins_home " 
mkdir -p ~/$DIR 
fi 

cd backup 
if [ -f "$BACKUP_FILE" ];
then
  rm $BACKUP_FILE
fi  
rsync  -av  /var/lib/docker/volumes/jenkins_home   . 
sudo chown -R ubuntu:ubuntu jenkins_home
tar cvfz  $BACKUP_FILE  jenkins_home

if [ -f "$BACKUP_FILE" ];
then
rm -rf jenkins_home
count=$(aws s3 ls s3://$DIRS3 | wc -l )
  if [ $count -gt 1 ];
  then
    aws s3 rm s3://$DIRS3/$BACKUP_OLD
    aws s3 mv  s3://$DIRS3/$BACKUP_FILE  s3://$DIRS3/$BACKUP_OLD 
  elif [ $count -eq 1 ];
  then
      if [ -f "aws s3 ls s3://$DIRS3/$BACKUP_OLD" ];
      then
        aws s3 rm s3://$DIRS3/$BACKUP_OLD
      else        
        aws s3 mv  s3://$DIRS3/$BACKUP_FILE  s3://$DIRS3/$BACKUP_OLD
      fi  
  fi  
fi
aws s3 sync .  s3://$DIRS3
rm $BACKUP_FILE  
cd ..

echo
echo "****Jenkins backup complete ****"
 echo
