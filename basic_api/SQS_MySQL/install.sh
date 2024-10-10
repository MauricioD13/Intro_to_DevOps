#!/bin/bash

apt update
apt upgrade

apt install git curl python3.12 python3-pip python3-venv

mkdir prod
cd prod

git clone 
python3 -m venv .env

source .env/bin/activate

