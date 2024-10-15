#!/bin/bash

apt update
apt upgrade

apt install git curl python3.12 python3-pip python3-venv

mkdir prod
cd prod

git clone https://github.com/MauricioD13/Intro_to_terraform/tree/main/basic_api/SQS_MySQL/app
python3 -m venv .env

source .env/bin/activate

pip3 install -r requirements.txt

uvicorn 

