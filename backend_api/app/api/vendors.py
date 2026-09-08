from fastapi import APIRouter
import os
from pydantic import BaseModel
from app.core.db import db

class VendorCreate(BaseModel):
    uid: str
    business_name: str
    email: str

router = APIRouter()

@router.get("/")
async def get_vendors():
    cursor = db.client[os.getenv("DATABASE_NAME", "my_animal")]["vendors"].find({})
    vendors = await cursor.to_list(length=100)
    for v in vendors:
        v["_id"] = str(v["_id"])
    return vendors

@router.post("/register")
async def register_vendor(vendor: VendorCreate):
    result = await db.client[os.getenv("DATABASE_NAME", "my_animal")]["vendors"].insert_one(vendor.dict())
    return {"_id": str(result.inserted_id), **vendor.dict()}

from pydantic import BaseModel
class VendorStatusUpdate(BaseModel):
    status: str

@router.put("/{vendor_id}/status")
async def update_vendor_status(vendor_id: str, update: VendorStatusUpdate):
    from bson.objectid import ObjectId
    await db.client[os.getenv("DATABASE_NAME", "my_animal")]["vendors"].update_one(
        {"_id": ObjectId(vendor_id)},
        {"$set": {"status": update.status}}
    )
    return {"message": f"Vendor status updated to {update.status}"}
