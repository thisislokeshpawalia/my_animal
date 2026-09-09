from fastapi import APIRouter
import os
from app.core.db import db
from app.models.schemas import ReviewBase

router = APIRouter()

@router.get("/")
async def get_all_reviews():
    cursor = db.client[os.getenv("DATABASE_NAME", "my_animal")]["reviews"].find({}).sort("created_at", -1)
    reviews = await cursor.to_list(length=100)
    for r in reviews:
        r["_id"] = str(r["_id"])
    return reviews

@router.get("/{product_id}")
async def get_reviews(product_id: str):
    cursor = db.client[os.getenv("DATABASE_NAME", "my_animal")]["reviews"].find({"product_id": product_id}).sort("created_at", -1)
    reviews = await cursor.to_list(length=100)
    for r in reviews:
        r["_id"] = str(r["_id"])
    return reviews

@router.post("/")
async def create_review(review: ReviewBase):
    review_dict = review.dict()
    result = await db.client[os.getenv("DATABASE_NAME", "my_animal")]["reviews"].insert_one(review_dict)
    
    # Optional: Update the product's average rating here or let the client calculate it.
    # For now, we will let the client fetch and calculate, or we can just return success.
    
    return {"_id": str(result.inserted_id), **review_dict}

@router.delete("/{review_id}")
async def delete_review(review_id: str):
    from bson.objectid import ObjectId
    await db.client[os.getenv("DATABASE_NAME", "my_animal")]["reviews"].delete_one({"_id": ObjectId(review_id)})
    return {"message": "Review deleted"}
