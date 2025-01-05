from sqlalchemy import create_engine, URL
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
import aws_config

"""
param_names = [
    "/myapp/prod/db_username",
    "/myapp/prod/db_password",
    "/myapp/prod/db_endpoint",
]

params = aws_config.get_parameters(param_names, region="eu-west-1")

# FOR DOCKER
SQLALCHEMY_DATABASE_URL = URL.create(
    "mysql+pymysql",
    username = "bitnami",
    password = "Test.123",
    host = "db",
    database = "myapp"
)
engine = create_engine(SQLALCHEMY_DATABASE_URL)
"""


# SQLALCHEMY_DATABASE_URL = "mysql+pymysql://bitnami:test123@db:3306/myapp"
# SQLALCHEMY_DATABASE_URL = "mysql+pymysql://fastapi:Test.123@locahost:3306/myapp"
# DB_URL = "mysql+pymysql://{db_username}:{db_password}@localhost:3306/{db_name}"
engine = create_engine(
    "sqlite:///./sql_app.db", connect_args={"check_same_thread": False}
)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()
