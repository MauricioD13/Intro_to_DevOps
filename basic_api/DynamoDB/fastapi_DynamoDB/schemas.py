from pydantic import BaseModel, Field
from typing import List, Optional

class MessageRecipe(BaseModel):
    name: str
    ingredients: List[str]
    instructions: List[str]
    cook_time: int = Field(gt=0)

class RecipeCreate(MessageRecipe):
    RecipeId: str

class RecipeSearch(MessageRecipe):
    pass