# jenkins-in-docker-aws
jenkins in docker for aws


```
# Scripts will help to reduce time for recover Jenkins configuration

1  Set aws user with for terraform ENV variable: << export TF_VAR_profile="user_profile" >>
   CD into terraform-jenkins-master-agent/
   use terraform apply to provision instances

2  Connect with ssh to agent node
    execute script at /tmp/agent.sh
    source /tmp/agent.sh

3   Connect with ssh to master node
    execute script at /tmp/master.sh
    source /tmp/master.sh  

4   Navigate JenkinsUI on browser with Jenkins-master-IP:8080
    user:admin
    password:admin 

5   Configure agent configuration
    update agent-IP

6   Run on jenkins-master
    Update known_hosts file, with below command:    
    docker exec myjenkins sh -c  "ssh-keyscan -H Jenkins-Agent-IP  >>  /var/jenkins_home/.ssh/known_hosts" 

7   You can restart agent descovery if keeps failing

8   Run backup.sh to store your configuration to AWS S3


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
 

```
