from fastapi import APIRouter, HTTPException, Depends
from pydantic import BaseModel, EmailStr
from passlib.context import CryptContext
import jwt
from fastapi.security import OAuth2PasswordBearer
from datetime import datetime, timedelta
import os
from app.core.db import db
from app.models.schemas import UserCreate, User

router = APIRouter()

SECRET_KEY = os.getenv("SECRET_KEY", "supersecretkey")
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 60 * 24 * 7 # 1 week

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/api/auth/login")

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

class Token(BaseModel):
    access_token: str
    token_type: str

class LoginData(BaseModel):
    email: str
    password: str

def verify_password(plain_password, hashed_password):
    return pwd_context.verify(plain_password, hashed_password)

def get_password_hash(password):
    return pwd_context.hash(password)

def create_access_token(data: dict, expires_delta: timedelta | None = None):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=15)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt

@router.post("/register", response_model=Token)
async def register(user: UserCreate):
    collection = db.client[os.getenv("DATABASE_NAME", "my_animal")]["users"]
    
    existing_user = await collection.find_one({"email": user.email})
    if existing_user:
        raise HTTPException(status_code=400, detail="Email already registered")
        
    hashed_password = get_password_hash(user.password)
    
    user_dict = user.dict()
    user_dict["password"] = hashed_password
    user_dict["created_at"] = datetime.utcnow()
    
    result = await collection.insert_one(user_dict)
    
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": str(result.inserted_id), "email": user.email, "role": user.role},
        expires_delta=access_token_expires
    )
    
    return {"access_token": access_token, "token_type": "bearer"}

@router.post("/login", response_model=Token)
async def login(login_data: LoginData):
    collection = db.client[os.getenv("DATABASE_NAME", "my_animal")]["users"]
    
    user = await collection.find_one({"email": login_data.email})
    if not user:
        raise HTTPException(status_code=400, detail="Incorrect email or password")
        
    if not verify_password(login_data.password, user["password"]):
        raise HTTPException(status_code=400, detail="Incorrect email or password")
        
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": str(user["_id"]), "email": user["email"], "role": user.get("role", "customer")},
        expires_delta=access_token_expires
    )
    
    return {"access_token": access_token, "token_type": "bearer"}

async def get_current_user(token: str = Depends(oauth2_scheme)):
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        email = payload.get("email")
        if email is None:
            raise HTTPException(status_code=401, detail="Invalid credentials")
    except jwt.PyJWTError:
        raise HTTPException(status_code=401, detail="Invalid credentials")
        
    collection = db.client[os.getenv("DATABASE_NAME", "my_animal")]["users"]
    user = await collection.find_one({"email": email})
    if user is None:
        raise HTTPException(status_code=401, detail="User not found")
        
    user["_id"] = str(user["_id"])
    return user

@router.get("/me")
async def get_me(current_user: dict = Depends(get_current_user)):
    return current_user

@router.get("/users")
async def get_all_users():
    collection = db.client[os.getenv("DATABASE_NAME", "my_animal")]["users"]
    cursor = collection.find({})
    users = await cursor.to_list(length=100)
    for u in users:
        u["_id"] = str(u["_id"])
    return users

class UserUpdate(BaseModel):
    loyalty_points: int = None
    role: str = None
    status: str = None

@router.put("/users/{user_id}")
async def update_user(user_id: str, user_update: UserUpdate):
    from bson.objectid import ObjectId
    collection = db.client[os.getenv("DATABASE_NAME", "my_animal")]["users"]
    update_data = {k: v for k, v in user_update.dict().items() if v is not None}
    await collection.update_one({"_id": ObjectId(user_id)}, {"$set": update_data})
    return {"message": "User updated"}
