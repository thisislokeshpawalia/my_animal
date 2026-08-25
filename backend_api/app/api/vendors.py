from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.core.db import get_db
from app.models.domain import VendorModel
from pydantic import BaseModel

class VendorCreate(BaseModel):
    uid: str
    business_name: str
    email: str

router = APIRouter()

@router.get("/")
def get_vendors(db: Session = Depends(get_db)):
    return db.query(VendorModel).all()

@router.post("/register")
def register_vendor(vendor: VendorCreate, db: Session = Depends(get_db)):
    db_vendor = VendorModel(**vendor.dict())
    db.add(db_vendor)
    db.commit()
    db.refresh(db_vendor)
    return db_vendor
