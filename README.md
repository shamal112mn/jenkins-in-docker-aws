# jenkins-in-docker-aws
jenkins in docker for aws


```
# Scripts will help to reduce time for reinstallation of Jenkins

# Script will backup jenkins_home and uploaded to AWS S3 bucket
# as archive in zip format ( jenkins-backup.tar.gz)
backup.sh 


# Script will restore jenkins_home from AWS S3 bucket
# Delete and replace current jenkins_home 

restore.sh

to set the agent known_host key

docker exec -ti myjenkins bash
# check if file exist /var/jenkins_home/.ssh/known_hosts
# then run command
ssh-keyscan -H IP-of-agent  >>  /var/jenkins_home/.ssh/known_hosts

# or just run below, just update IP
docker exec myjenkins sh -c  "ssh-keyscan -H Agent-IP  >>  /var/jenkins_home/.ssh/known_hosts" 

```
