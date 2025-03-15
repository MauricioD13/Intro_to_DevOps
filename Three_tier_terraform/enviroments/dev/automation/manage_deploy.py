import boto3
import os
import sys

client = boto3.client('rds')

def rds_management():
    print(client.describe_db_instances())
    