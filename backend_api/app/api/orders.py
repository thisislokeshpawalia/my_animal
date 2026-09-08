from fastapi import APIRouter
import os
from app.core.db import db
from app.models.schemas import OrderBase

router = APIRouter()

@router.get("/")
async def get_orders():
    cursor = db.client[os.getenv("DATABASE_NAME", "my_animal")]["orders"].find({})
    orders = await cursor.to_list(length=100)
    for o in orders:
        o["_id"] = str(o["_id"])
    return orders

@router.post("/")
async def create_order(order: OrderBase):
    result = await db.client[os.getenv("DATABASE_NAME", "my_animal")]["orders"].insert_one(order.dict())
    return {"_id": str(result.inserted_id), **order.dict()}
