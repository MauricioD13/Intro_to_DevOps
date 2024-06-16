#!/bin/bash

apt install python3
apt install python3-pip
pip install flask

echo 'from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello_world():
    return "<h1>Hello world</h1>"' > api.py

flask --app api run