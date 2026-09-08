from fastapi import APIRouter, HTTPException
import os
from bson import ObjectId
from app.core.db import db
from app.models.schemas import PetBase

router = APIRouter()

def get_db_collection():
    return db.client[os.getenv("DATABASE_NAME", "my_animal")]["pets"]

@router.post("/")
async def create_pet(pet: PetBase):
    collection = get_db_collection()
    result = await collection.insert_one(pet.dict())
    return {"_id": str(result.inserted_id), **pet.dict()}

@router.get("/{user_id}")
async def get_user_pets(user_id: str):
    collection = get_db_collection()
    cursor = collection.find({"user_id": user_id})
    pets = await cursor.to_list(length=100)
    for p in pets:
        p["_id"] = str(p["_id"])
    return pets

@router.get("/pet/{pet_id}")
async def get_pet(pet_id: str):
    collection = get_db_collection()
    try:
        pet = await collection.find_one({"_id": ObjectId(pet_id)})
    except Exception:
        raise HTTPException(status_code=400, detail="Invalid Pet ID format")
        
    if not pet:
        raise HTTPException(status_code=404, detail="Pet not found")
        
    pet["_id"] = str(pet["_id"])
    return pet
