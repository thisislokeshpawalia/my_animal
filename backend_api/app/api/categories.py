from fastapi import APIRouter
from app.core.db import db
import os

router = APIRouter()

@router.get("/")
async def get_categories():
    categories = await db.client[os.getenv("DATABASE_NAME", "my_animal")]["products"].distinct("category")
    return [c for c in categories if c]
