from pydantic import BaseModel, Field

class HealthResponse(BaseModel):
    status: str 
    version: str 
    environment: str

class ItemResponse(BaseModel):
    item_id: int = Field(..., description="The unique identifier for the item", example=1, gt=0, le=100)
    name: str 
    description: str 

