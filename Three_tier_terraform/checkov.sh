#!/bin/bash

terraform plan -out tf.plan
terraform show -json tf.plan | jq > tf.json 
checkov -f tf.json
