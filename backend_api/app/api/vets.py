from fastapi import APIRouter, HTTPException
import os
from bson import ObjectId
from app.core.db import db
from app.models.schemas import VetConsultationBase
from typing import Literal

router = APIRouter()

def get_db_collection():
    return db.client[os.getenv("DATABASE_NAME", "my_animal")]["consultations"]

@router.post("/consultations/")
async def book_consultation(consultation: VetConsultationBase):
    collection = get_db_collection()
    result = await collection.insert_one(consultation.dict())
    return {"_id": str(result.inserted_id), **consultation.dict()}

@router.get("/consultations/user/{user_id}")
async def get_user_consultations(user_id: str):
    collection = get_db_collection()
    cursor = collection.find({"user_id": user_id})
    consultations = await cursor.to_list(length=100)
    for c in consultations:
        c["_id"] = str(c["_id"])
    return consultations

@router.get("/consultations/vet/{vet_id}")
async def get_vet_consultations(vet_id: str):
    collection = get_db_collection()
    cursor = collection.find({"vet_id": vet_id})
    consultations = await cursor.to_list(length=100)
    for c in consultations:
        c["_id"] = str(c["_id"])
    return consultations

@router.patch("/consultations/{consultation_id}/status")
async def update_consultation_status(consultation_id: str, status: str):
    collection = get_db_collection()
    try:
        obj_id = ObjectId(consultation_id)
    except Exception:
        raise HTTPException(status_code=400, detail="Invalid Consultation ID format")
        
    result = await collection.update_one(
        {"_id": obj_id},
        {"$set": {"status": status}}
    )
    
    if result.modified_count == 0:
        raise HTTPException(status_code=404, detail="Consultation not found or status is already set")
        
    updated = await collection.find_one({"_id": obj_id})
    updated["_id"] = str(updated["_id"])
    return updated
