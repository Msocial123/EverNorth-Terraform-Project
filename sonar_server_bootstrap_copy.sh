#!/bin/bash

#Update the machine
sudo apt-get update

#install OpenJDK 17
sudo apt-get install openjdk-17-jre -y

#check Installed Java Version
java -version

#Release apt-get lock in case if its locked
#Issue : Could not get lock /var/lib/dpkg/lock-frontend
sudo rm /var/lib/apt/lists/lock
sudo rm /var/cache/apt/archives/lock
sudo rm /var/lib/dpkg/lock*
sudo dpkg --configure -a

sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
sudo echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package lists
sudo apt-get update

#install the latest version of Docker packages
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Create the docker group if it does not exist
sudo groupadd docker

# Add your user to the docker group.
sudo usermod -aG docker $USER

# Log in to the new docker group (to avoid having to log out / log in again; but if not enough, try to reboot):
newgrp docker

#restart the docker
sudo systemctl restart docker

# Change the permissions of docker socket to be able to connect to the docker daemon
sudo chmod 777 /var/run/docker.sock

# Run SonarQube on Jenkin server for continuous inspection of code quality on host port 9000
#https://hub.docker.com/_/sonarqube
docker run -d --name sonarqube -p 9000:9000 sonarqube:lts-community
