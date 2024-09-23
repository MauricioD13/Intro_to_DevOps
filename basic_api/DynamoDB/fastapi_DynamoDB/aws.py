import boto3
from boto3.dynamodb.conditions import Key, Attr
import config
import os


session = boto3.Session(profile_name='personal')
dynamodb = session.resource('dynamodb')
table = dynamodb.Table(config.dynamoDB_table_name)