from pydantic import BaseModel, Field
from typing import List, Optional
from datetime import datetime

class Product(BaseModel):
    id: Optional[str] = Field(alias="_id", default=None)
    title: str
    price: float
    description: str
    category: str
    image: str
    rating: dict

class Category(BaseModel):
    id: Optional[str] = Field(alias="_id", default=None)
    name: str

class CartItem(BaseModel):
    product_id: str
    quantity: int

class Cart(BaseModel):
    id: Optional[str] = Field(alias="_id", default=None)
    user_id: str
    items: List[CartItem]
    
class Order(BaseModel):
    id: Optional[str] = Field(alias="_id", default=None)
    user_id: str
    items: List[CartItem]
    total: float
    status: str = "pending"
    created_at: datetime = Field(default_factory=datetime.utcnow)
