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
    


SQLALCHEMY_DATABASE_URL = URL.create(
    "mysql+pymysql",
    username = data["db_user"],
    password = data["db_pass"],
    host = "localhost",
    database = data["db_name"],
)
engine = create_engine(SQLALCHEMY_DATABASE_URL,connect_args={"check_same_thread": False})


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
