from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
import os

security = HTTPBearer(auto_error=False)

def get_current_user(credentials: HTTPAuthorizationCredentials = Depends(security)):
    # MOCK AUTHENTICATION FOR LOCAL DEVELOPMENT
    # When you get the real Firebase Service Account JSON, we will restore this.
    return {
        "uid": "mock-vendor-123",
        "email": "test@vendor.com",
        "phone_number": "+919876543210"
    }
