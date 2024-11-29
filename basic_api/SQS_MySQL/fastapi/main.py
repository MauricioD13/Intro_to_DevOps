# FastAPI Imports
from fastapi import FastAPI, Depends, HTTPException, Request, Form
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
from fastapi.responses import HTMLResponse, RedirectResponse
from sqlalchemy.orm import Session

# Local Imports
from app import crud
from app import models
from app import schemas
from app.database import SessionLocal, engine
import asyncio

models.Base.metadata.create_all(bind=engine)


# Dependency
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


app = FastAPI()
counter = 0
app.mount("/static", StaticFiles(directory="static"), name="static")

templates = Jinja2Templates(directory="templates")

# SIGN UP


@app.get("/signup", response_class=HTMLResponse)
async def get_users(request: Request):
    return templates.TemplateResponse("signup.html", {"request": request})


# Endpoint to handle user sign-up
@app.post("/signup", response_model=schemas.User)
def post_signup(user: schemas.UserCreate, db: Session = Depends(get_db)):
    user_exists = crud.get_user_by_email(db=db, email=user.email)
    if not user_exists:
        db_user = crud.create_user(db=db, user=user)
        if not db_user:
            raise HTTPException(status_code=400, detail="Email already registered")
        return db_user
    raise HTTPException(status_code=400, detail="Email already registered")


# USERS


@app.post("/users/", response_model=schemas.User)
def create_user(user: schemas.UserCreate, db: Session = Depends(get_db)):
    db_user = crud.get_user_by_email(db, email=user.email)
    if db_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    return crud.create_user(db=db, user=user)


@app.get("/users/", response_model=list[schemas.User])
def read_users(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    users = crud.get_users(db, skip=skip, limit=limit)
    return users


@app.get("/users/{user_id}", response_class=HTMLResponse)
def read_user(request: Request, user_id: int, db: Session = Depends(get_db)):
    db_user = crud.get_user(db, user_id=user_id)
    if db_user is None:
        raise HTTPException(status_code=404, detail="User not found")
    print(db_user)
    return templates.TemplateResponse(
        "user_id.html", {"request": request, "db_user": db_user}
    )


@app.get("/users_all/", response_class=HTMLResponse)
def get_users(
    request: Request, db: Session = Depends(get_db), skip: int = 0, limit: int = 10
):
    users = crud.get_users(db, skip=skip, limit=limit)
    return templates.TemplateResponse(
        "users.html", {"request": request, "users": users}
    )


# HOME


@app.get("/", response_class=HTMLResponse)
def home_page(request: Request):
    return templates.TemplateResponse("home.html", {"request": request})


# RECIPES
@app.get("/recipe/", response_model=list[schemas.Recipe])
def read_recipes(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    recipes = crud.get_recipes(db, skip=skip, limit=limit)
    return recipes


@app.post("/users/{user_id}/recipes/", response_model=schemas.Recipe)
def create_recipe_for_user(
    user_id: int, recipe: schemas.RecipeCreate, db: Session = Depends(get_db)
):
    print(recipe.ingredients)
    return crud.create_user_recipe(db=db, recipe=recipe, user_id=int(user_id))
