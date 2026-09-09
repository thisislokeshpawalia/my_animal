from pydantic import BaseModel, Field
from typing import List, Optional
from datetime import datetime

class UserBase(BaseModel):
    uid: str = ""
    email: str
    full_name: str = ""
    phone: str = ""
    role: str = "user" # user, vendor, admin
    loyalty_points: int = 0
    created_at: datetime = Field(default_factory=datetime.utcnow)

class UserCreate(UserBase):
    password: str
    name: str = ""

class User(UserBase):
    id: Optional[str] = Field(alias="_id", default=None)

class PetBase(BaseModel):
    user_id: str
    name: str
    species: str # dog, cat, cow, fish, etc.
    breed: str = ""
    age: int = 0
    health_notes: str = ""

class Pet(PetBase):
    id: Optional[str] = Field(alias="_id", default=None)

class VendorBase(BaseModel):
    uid: str
    business_name: str
    email: str
    phone: str = ""
    status: str = "pending" # pending, approved, suspended

class Vendor(VendorBase):
    id: Optional[str] = Field(alias="_id", default=None)

class ProductBase(BaseModel):
    title: str
    price: float
    description: str = ""
    category: str = ""
    image: str = ""
    vendor_id: str = ""
    rating: dict = {"average": 0.0, "count": 0}

class Product(ProductBase):
    id: Optional[str] = Field(alias="_id", default=None)

class CategoryBase(BaseModel):
    name: str
    type: str = "product" # product, livestock, aquatic

class Category(CategoryBase):
    id: Optional[str] = Field(alias="_id", default=None)

class OrderItem(BaseModel):
    productName: str
    image: str
    quantity: int
    price: float

class OrderBase(BaseModel):
    id: str = Field(alias="_id", default=None)
    items: List[OrderItem]
    price: float
    orderDate: datetime = Field(default_factory=datetime.utcnow)
    status: str = "pending"
    trackingId: str = ""
    receiverName: str = ""
    contactNumber: str = ""
    deliveryAddress: str = ""
    customerEmail: str = ""
    is_subscription: bool = False
    frequency: str = "" # weekly, monthly, bi-monthly
    redeem_points: int = 0

class Order(OrderBase):
    pass

class ReviewBase(BaseModel):
    user_id: str
    product_id: str = ""
    vendor_id: str = ""
    rating: int = 5
    comment: str = ""
    created_at: datetime = Field(default_factory=datetime.utcnow)

class Review(ReviewBase):
    id: Optional[str] = Field(alias="_id", default=None)

class VetConsultationBase(BaseModel):
    user_id: str
    pet_id: str
    vet_id: str
    appointment_date: datetime
    status: str = "scheduled" # scheduled, completed, cancelled

class VetConsultation(VetConsultationBase):
    id: Optional[str] = Field(alias="_id", default=None)

class VetBase(BaseModel):
    name: str
    specialty: str
    experience_years: int
    rating: float
    consultation_fee: float
    image_url: str = ""

class Vet(VetBase):
    id: Optional[str] = Field(alias="_id", default=None)
