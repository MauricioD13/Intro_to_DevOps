from sqlalchemy import create_engine, URL
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
import os
import json
"""
param_names = [
    "/myapp/prod/db_username",
    "/myapp/prod/db_password",
    "/myapp/prod/db_endpoint",
]
"""
#params = aws_config.get_parameters(param_names, region="eu-west-1")

with open('data.json', 'r') as file:
    data = json.load(file)
    
USERNAME = "fastapi"
PASSWORD = "fastapi"
HOST = "localhost"
DATABASE = "recipes"
PORT = 3306

DATABASE_URL = f"mysql+pymysql://{USERNAME}:{PASSWORD}@{HOST}:{PORT}/{DATABASE}"
"""URL.create(
    "mysql+pymysql",
    username = "fastapi",
    password = "fastapi",
    host = "localhost",
    database = "recipes",
    port = 3306
)"""
engine = create_engine(DATABASE_URL)


# SQLALCHEMY_DATABASE_URL = "mysql+pymysql://bitnami:test123@db:3306/myapp"
# SQLALCHEMY_DATABASE_URL = "mysql+pymysql://fastapi:Test.123@locahost:3306/myapp"
# DB_URL = "mysql+pymysql://{db_username}:{db_password}@localhost:3306/{db_name}"
"""
engine = create_engine(
    "sqlite:///./sql_app.db", connect_args={"check_same_thread": False}
)
"""
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()
