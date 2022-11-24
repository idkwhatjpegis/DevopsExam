#!/bin/bash

# 
# Create Jenkins job
# 

java -jar /home/vagrant/jenkins-cli.jar -s http://192.168.111.100:8080/ -http -auth admin:admin create-job Exam < /vagrant/jenkins/job.xml
