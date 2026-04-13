from fastapi import FastAPI, HTTPException
from models import HealthResponse, ItemResponse
import os 

app = FastAPI(
    title="Deployment Pipeline Demo",
    description="A FastAPI app deployed via Jenkins + Docker + Helm + K8s",
    version="1.0.0"
)

APP_VERSION = os.getenv("APP_VERSION", "1.0.0")
ENVIRONMENT = os.getenv("ENVIRONMENT", "production")

ITEMS = {
    1: {"name": "Widget A", "description": "A sample widget"},
    2: {"name": "Widget B", "description": "Another sample widget"},
    3: {"name": "Widget C", "description": "Yet another sample widget"},
}

@app.get("/") 

def read_root():
    return {"message": "Welcome to the Deployment Pipeline Demo API!"}

@app.get("/health", response_model=HealthResponse)
def health_check():
    return HealthResponse(
        status="healthy",
        version=APP_VERSION,
        environment=ENVIRONMENT
    ) 

@app.get("/items/{item_id}", response_model=ItemResponse)
def read_item(item_id: int):
    item = ITEMS.get(item_id)

    if item:
        return ItemResponse(
            item_id=item_id,
            **item 
        )
    
    raise HTTPException(status_code=404, detail="Item not found")


