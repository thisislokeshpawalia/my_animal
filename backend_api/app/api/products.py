from fastapi import APIRouter
import os
import re
from pydantic import BaseModel
from app.core.db import db

class ProductCreate(BaseModel):
    title: str
    description: str = ""
    price: float
    category: str = ""
    image: str = ""
    vendor_id: str = ""

router = APIRouter()

from typing import Optional

@router.get("/")
async def get_products(q: Optional[str] = None, category: Optional[str] = None):
    query = {}
    if q:
        query["title"] = {"$regex": q, "$options": "i"}
    if category:
        query["category"] = category
        
    cursor = db.client[os.getenv("DATABASE_NAME", "my_animal")]["products"].find(query)
    products = await cursor.to_list(length=100)
    for p in products:
        p["_id"] = str(p["_id"])
    return products

@router.get("/recommendations/{user_id}")
async def get_product_recommendations(user_id: str):
    pets_cursor = db.client[os.getenv("DATABASE_NAME", "my_animal")]["pets"].find({"user_id": user_id})
    pets = await pets_cursor.to_list(length=50)
    
    keywords = set()
    for pet in pets:
        if pet.get("species"):
            keywords.add(pet["species"].lower())
        if pet.get("breed"):
            keywords.add(pet["breed"].lower())
            
    if keywords:
        regex_pattern = "|".join([re.escape(k) for k in keywords])
        query = {
            "$or": [
                {"title": {"$regex": regex_pattern, "$options": "i"}},
                {"category": {"$regex": regex_pattern, "$options": "i"}},
                {"description": {"$regex": regex_pattern, "$options": "i"}}
            ]
        }
    else:
        query = {}
        
    cursor = db.client[os.getenv("DATABASE_NAME", "my_animal")]["products"].find(query).limit(10)
    products = await cursor.to_list(length=10)
    for p in products:
        p["_id"] = str(p["_id"])
    return products

@router.post("/")
async def create_product(product: ProductCreate):
    result = await db.client[os.getenv("DATABASE_NAME", "my_animal")]["products"].insert_one(product.dict())
    return {"_id": str(result.inserted_id), **product.dict()}

@router.delete("/{product_id}")
async def delete_product(product_id: str):
    from bson.objectid import ObjectId
    await db.client[os.getenv("DATABASE_NAME", "my_animal")]["products"].delete_one({"_id": ObjectId(product_id)})
    return {"message": "Product deleted"}

@router.put("/{product_id}")
async def update_product(product_id: str, product: ProductCreate):
    from bson.objectid import ObjectId
    await db.client[os.getenv("DATABASE_NAME", "my_animal")]["products"].update_one(
        {"_id": ObjectId(product_id)},
        {"$set": product.dict()}
    )
    return {"message": "Product updated"}
