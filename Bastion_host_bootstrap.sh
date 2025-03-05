#!/bin/bash

#Download the latest release
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
#Validate the binary (optional)
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
#Validate the kubectl binary against the checksum file:
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
#Install kubectl
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl   
#Test to ensure the version you installed is up-to-date:
kubectl version --client

sudo dnf update -y
sudo dnf install mariadb105 -y

sudo dnf update -y
sudo dnf install -y httpd php php-mysqli mariadb105
sudo systemctl start httpd
sudo systemctl enable httpd
sudo bash -c 'echo Bastion server for Database subnet RDS > /var/www/html/index.html'