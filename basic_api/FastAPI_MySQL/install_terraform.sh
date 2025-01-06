#!/bin/bash

set -e

# Install Ansible
sudo apt install -y pipx python3-pip python3 gnupg software-properties-common curl
python3 -m pipx ensurepath
source ~/.bashrc
pipx install --include-deps ansible


# Install Terraform
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install -y terraform

# Verify installation
terraform --version
ansible --version