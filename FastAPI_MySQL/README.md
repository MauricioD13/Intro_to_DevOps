# Automating a Recipe Server Deployment: FastAPI, Terraform, and Ansible

This project, a **FastAPI-based Recipe Server**, became my hands-on experiment to automate end-to-end deployment, from infrastructure provisioning to application setup, while prioritizing security best practices in some topics, there is much space for improvement.

Here is an article with more detail: [link](https://tech-mauricio.me/projects/project_recipe_server/)

### Administration node

To configure the administration node use the script called


    installed_tools.sh


Because of the nature of pipx is necessary to logout and login to be able to use the ansible commands. After all the tools are installed, use the AWS CLI to create a EC2 key pair with the following comands:


    aws ec2 create-key-pair --key-name tf_key | jq -r ".KeyMaterial" > ~/.ssh/ec2_key.pem

    chmod 400 ~/.ssh/ec2_key.pem

    ssh-add ~/.ssh/ec2_key.pem


Copy it in the following path: '~/.ssh/ec2_key.pem'. You could change to name but also need to change the deployment script and the ansible inventory template.

Finally, use the script:

    deploy.sh