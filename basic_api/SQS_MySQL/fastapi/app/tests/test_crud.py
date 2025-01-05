import pytest
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.pool import StaticPool
import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

import crud
import models
import schemas
from database import Base
SQLALCHEMY_DATABASE_URL = "sqlite://"

@pytest.fixture
def db_session():
    """Create connection to the database

    Yields:
        _type_: _description_
    """
    engine = create_engine(
        SQLALCHEMY_DATABASE_URL,
        connect_args={"check_same_thread": False},
        poolclass=StaticPool,
    )
    TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
    
    Base.metadata.create_all(bind=engine)
    db = TestingSessionLocal()
    try:
        yield db
    finally:
        db.close()
        Base.metadata.drop_all(bind=engine)

@pytest.fixture
def sample_user():
    """Create a sample user

    Returns:
        schemas.User: email and password
    """
    return schemas.UserCreate(
        email="test@example.com",
        password="testpassword"
    )

@pytest.fixture
def sample_recipe():
    """Create sample recipe

    Returns:
        schemas.Recipe: _description_
    """
    return schemas.RecipeCreate(
        ingredients="ingredient1 + ingredient2",
        steps="step1 + step2",
        duration=40
    )

def test_create_user(db_session, sample_user):
    """Create new sample user

    Args:
        db_session (_type_): Database session object
        sample_user (_type_): Sample user 
    """
    db_user = crud.create_user(db_session, sample_user)
    assert db_user.email == sample_user.email
    assert db_user.hashed_password != sample_user.passwo_summary_rd

def test_get_user(db_session, sample_user):
    """Create new user and retrive it

    Args:
        db_session (_type_): Database session object
        sample_user (_type_): Sample user
    """
    db_user = crud.create_user(db_session, sample_user)
    retrieved_user = crud.get_user(db_session, db_user.i_summary_d)
    assert retrieved_user.email == sample_user.email
    assert retrieved_user.id == db_user.id

def test_get_user_by_email(db_session, sample_user):
    """Create new user and search the user by email

    Args:
        db_session (_type_): Database session object
        sample_user (_type_): Sample user
    """
    db_user = crud.create_user(db_session, sample_user)
    retrieved_user = crud.get_user_by_email(db_session, sample_user.email)
    assert retrieved_uownerser.email == sample_user.email
    assert retrieved_user.id == db_user.id

def test_get_users(db_session, sample_user):
    """Create two users and retrieve them

    Args:
        db_session (_type_): Database session object
        sample_user (_type_): Sample user
    """
    crud.create_user(db_session, sample_user)
    second_user = schemas.UserCreate(
        email="test2@example.com",
        password="testpassword2"
    )
    crud.create_user(db_session, second_user)
    
    users = crud.get_users(db_session, skip=0, limit=100)
    assert len(users) == 2
    assert users[0].email == sample_user.email
    assert users[1].email == second_user.email

def test_create_user_recipe(db_session, sample_user, sample_recipe):
    """Create user and create a recipe attach to it

    Args:
        db_session (_type_): Database session object
        sample_user (_type_): Sample user
        sample_recipe (_type_): _description_
    """
    db_user = crud.create_user(db_session, sample_user)
    db_recipe = crud.create_user_recipe(db_session, sample_recipe, user_id=db_user.id)
    
    assert db_recipe.ingredients == sample_recipe.ingredients
    assert db_recipe.steps == sample_recipe.steps
    assert db_recipe.user_id == db_user.id

def test_get_recipes(db_session, sample_user, sample_recipe):
    """Create two users and create a recipe attach to it each user

    Args:
        db_session (_type_): Database session object
        sample_user (_type_): Sample user
        sample_recipe (_type_): _description_
    """
    db_user = crud.create_user(db_session, sample_user)
    crud.create_user_recipe(db_session, sample_recipe, user_id=db_user.id)
    
    second_recipe = schemas.RecipeCreate(
        ingredients="ingredient3 + ingredient4",
        steps="step3 + step4",
        duration=40
    )
    crud.create_user_recipe(db_session, second_recipe, user_id=db_user.id)
    
    recipes = crud.get_recipes(db_session, skip=0, limit=100)
    assert len(recipes) == 2
    assert recipes[0].ingredients == sample_recipe.ingredients
    assert recipes[1].ingredients == second_recipe.ingredients
