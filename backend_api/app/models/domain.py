from sqlalchemy import Column, Integer, String, Float, Boolean
from app.core.db import Base

class ProductModel(Base):
    __tablename__ = "products"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, index=True)
    description = Column(String)
    price = Column(Float)
    category = Column(String)
    image = Column(String)
    vendor_id = Column(String)

class VendorModel(Base):
    __tablename__ = "vendors"

    id = Column(Integer, primary_key=True, index=True)
    uid = Column(String, unique=True, index=True)
    business_name = Column(String)
    email = Column(String)
    status = Column(String, default="pending")
