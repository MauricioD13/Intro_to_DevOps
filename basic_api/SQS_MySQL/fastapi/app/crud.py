from sqlalchemy.orm import Session
from . import models
from . import schemas


def get_user(db: Session, user_id: int):
    return db.query(models.User).filter(models.User.id == user_id).first()


def get_user_by_email(db: Session, email: str):
    return db.query(models.User).filter(models.User.email == email).first()


def get_users(db: Session, skip: int = 0, limit: int = 10):
    return db.query(models.User).offset(skip).limit(limit).all()


def create_user(db: Session, user: schemas.UserCreate):
    """_summary_

    Args:
        db (Session): _description_
        user (schemas.UserCreate): _description_

    Returns:
        db_user (class 'app.models.User'): _description_
    """
    fake_hashed_password = user.password + "notreallyhashed"
    db_user = models.User(email=user.email, hashed_password=fake_hashed_password)
    print(type(db_user))
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user


def get_recipes(db: Session, skip: int = 0, limit: int = 100):
    return db.query(models.Recipe).offset(skip).limit(limit).all()


def create_user_recipe(db: Session, recipe: schemas.RecipeCreate, user_id: int):
    db_recipe = models.Recipe(**recipe.dict(), user_id=user_id)
    db.add(db_recipe)
    db.commit()
    db.refresh(db_recipe)
    return db_recipe
