# FastAPI Imports
from fastapi import FastAPI, Depends, HTTPException, Request
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
from fastapi.responses import HTMLResponse

# Other imports
import json

# Local Imports
import crud, schemas
import asyncio
from logger import logger


app = FastAPI()
counter = 0
app.mount("/static", StaticFiles(directory="static"), name="static")
templates = Jinja2Templates(directory="templates")


@app.get("/")
async def main(request: Request, response_class=HTMLResponse):
    
    template = "index.html"
    try:
        db_recipes = await crud.get_all_recipes()
    except:
        print("Error obtaining recipes")
    if not db_recipes:
        template = "no_recipes.html"
    return templates.TemplateResponse(
        template, {"request":request, "data":db_recipes}
    )
    

@app.get("/recipe/{recipe_id}")
async def read_recipe(recipe_id: int):
    db_recipe = await crud.get_recipe('id',recipe_id = recipe_id)
    if not db_recipe:
        raise HTTPException(status_code=404, detail="Recipe not found") 
    return db_recipe

@app.post("/recipe",response_model=schemas.RecipeCreate)
async def create_recipe(recipe: schemas.MessageRecipe):
    
    with open("params.json","r") as file:
        json_object = json.load(file)
        counter = json_object["counter"]
    
    recipe_create = schemas.RecipeCreate(
        RecipeId=counter,
        **recipe.dict()
    )
    try:
        db_recipe = await crud.create_recipe(recipe=recipe_create)
    except:
        logger.error("Recipe ID already exists")
        raise HTTPException(status_code=400, detail="Recipe Id already exists")
    if not db_recipe:
        raise HTTPException(status_code=400, detaisl="Error creating recipe")
    counter = int(counter) + 1
    counter = str(counter)
    print(f"Counter: {counter}")
    return create_recipe
