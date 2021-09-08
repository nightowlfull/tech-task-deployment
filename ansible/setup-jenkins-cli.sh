#!/bin/sh


export JENKINS_USER_ID=admin
export JENKINS_API_TOKEN="ADMIN_PASSWORD"

sleep 30

curl http://localhost:8080/jnlpJars/jenkins-cli.jar -o /var/lib/jenkins/jenkins-cli.jar

chown jenkins:jenkins /var/lib/jenkins/jenkins-cli.jar


## Installing Git plugin
java -jar /var/lib/jenkins/jenkins-cli.jar -s http://localhost:8080 install-plugin git

## Installing Github Webhook Plugin
java -jar /var/lib/jenkins/jenkins-cli.jar -s http://localhost:8080 install-plugin github

## 
java -jar /var/lib/jenkins/jenkins-cli.jar -s http://localhost:8080/ restart

sleep 30

## Added Github user/token for cloning repository
java -jar /var/lib/jenkins/jenkins-cli.jar -s http://localhost:8080/ create-credentials-by-xml  system::system::jenkins _ < /home/ubuntu/cred.xml

java -jar /var/lib/jenkins/jenkins-cli.jar -s http://localhost:8080 create-job test-task < /home/ubuntu/config.xml


java -jar /var/lib/jenkins/jenkins-cli.jar -s http://localhost:8080 build test-task
