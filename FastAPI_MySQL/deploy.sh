#!/bin/bash

set -e

echo "1. Initializing Terraform..."

cd terraform
terraform init

echo "2. Applying Terraform configuration..."
terraform apply -auto-approve

echo "3. Getting EC2 instance IP..."
INSTANCE_IP=$(terraform output -raw instance_public_ip)

echo "4. Waiting for instance to be ready..."
sleep 60

echo "5. Creating Ansible inventory..."
cd ../ansible
sed "s/\${terraform_ip}/$INSTANCE_IP/g" inventory.ini.template > inventory.ini

echo "6. Running Ansible playbook..."
ansible-playbook -i inventory.ini playbook.yml --ask-vault-pass

echo "Done! Your application is now deployed at http://$INSTANCE_IP:8000"
