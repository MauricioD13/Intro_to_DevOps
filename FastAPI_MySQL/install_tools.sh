#!/bin/bash

set -e
# aws --region eu-west-1 ec2 create-key-pair --key-name "tf_key" --query 'KeyMaterial' --output text > mykey.pem
# Install Ansible
sudo apt install -y unzip pipx python3-pip python3 gnupg software-properties-common curl
python3 -m pipx ensurepath
source ~/.bashrc
pipx install --include-deps ansible
pipx inject ansible passlib
pipx ensurepath
echo "re-login to apply changes and use ansible"

# Install Terraform
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install -y terraform

# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Verify installation
terraform --version
ansible --version
aws --version