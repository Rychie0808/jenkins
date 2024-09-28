#!/bin/bash 
sudo yum update -y 
sudo yum install java-11-openjdk-devel git -y 
sudo yum install wget -y 
sudo wget https://get.jenkins.io/redhat/jenkins-2.411-1.1.noarch.rpm 
sudo rpm -ivh jenkins-2.411-1.1 noarch.rpm 
sudo yum update -y 
sudo yum install jenkins -y 
sudo systemctl start jenkins
sudo systemctl enable jenkins 
