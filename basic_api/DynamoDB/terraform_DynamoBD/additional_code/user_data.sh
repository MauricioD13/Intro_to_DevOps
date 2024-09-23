#!/bin/bash

apt install python3
apt install python3-pip
python3 -m venv .env
source .env/bin/activate
pip install fastapi
pip install boto3
pip install pydantic

uvicorn main:app --reload