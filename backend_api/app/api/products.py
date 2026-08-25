from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.core.db import get_db
from app.models.domain import ProductModel
from pydantic import BaseModel

class ProductCreate(BaseModel):
    title: str
    description: str = ""
    price: float
    category: str = ""
    image: str = ""
    vendor_id: str = ""

router = APIRouter()

@router.get("/")
def get_products(db: Session = Depends(get_db)):
    products = db.query(ProductModel).all()
    return products

@router.post("/")
def create_product(product: ProductCreate, db: Session = Depends(get_db)):
    db_product = ProductModel(**product.dict())
    db.add(db_product)
    db.commit()
    db.refresh(db_product)
    return db_product
