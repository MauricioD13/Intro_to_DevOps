from pydantic import BaseModel

class RecipeBase(BaseModel):
    ingredients: str
    steps: str
    duration: int

class RecipeCreate(RecipeBase):
    pass

class Recipe(RecipeBase):
    id: int
    user_id: int

    class Config:
        orm_mode = True
class UserBase(BaseModel):
    email: str

class UserCreate(UserBase):
    password: str

class User(UserBase):
    id: int
    is_active: bool
    recipes: list[Recipe] = []

    class Config:
        orm_mode = True