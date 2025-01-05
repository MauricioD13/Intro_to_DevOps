
from sqlalchemy import Boolean, Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship

from database import Base


class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True,autoincrement=True)
    email = Column(String(200), unique=True, index=True)
    hashed_password = Column(String(200))
    is_active = Column(Boolean, default=True)
    recipes = relationship("Recipe", back_populates="owner")

class Recipe(Base):
    __tablename__ = "recipes"
    id = Column(Integer, primary_key=True)
    ingredients = Column(String(1000))
    steps = Column(String(2000))
    duration = Column(Integer)
    user_id = Column(Integer, ForeignKey('users.id'))
    owner = relationship("User", back_populates="recipes")
