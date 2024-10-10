from sqlalchemy import create_engine
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
"""
SQLALCHEMY_DATABASE_URL = "sqlite:///./sql_app.db"

engine = create_engine(
    SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False}
)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()
