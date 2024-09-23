# Terraform tools

1. TFlint
  curl -s <https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh> | bash

Block
  plugin "terraform" {
    enabled = true
    preset = "recommended"
  }

2. Terrascan

Static code analysis tool scan IaC for security vulnerabilities and compliance

    curl -L "$(curl -s <https://api.github.com/repos/tenable/terrascan/releases/latest> | grep -o -E "https://.+?_Darwin_x86_64.tar.gz")" > terrascan.tar.gz
    tar -xf terrascan.tar.gz terrascan && rm terrascan.tar.gz
    install terrascan /usr/local/bin && rm terrascan
    terrascan

3. Checkov

SAST, parsing configurations and evaluating

    pip3 install checkov
    checkov --file /user/tf/example.tf

