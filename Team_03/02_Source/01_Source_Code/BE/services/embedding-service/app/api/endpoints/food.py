from fastapi import APIRouter, HTTPException
from app.models.food import FoodEmbeddingCreate, FoodEmbeddingUpdate, FoodEmbeddingResponse 
from app.core.vectordb import vector_db_service

router = APIRouter()

@router.post("/", response_model=FoodEmbeddingResponse)
async def create_food_embedding(request: FoodEmbeddingCreate):
    try:
        success = vector_db_service.upsert_food(request.food_id, request.food_name)
        if not success:
            raise HTTPException(status_code=400, detail=f"Failed to create food embedding for {request.food_id}")
        return FoodEmbeddingResponse(message=f"Food embedding created successfully for {request.food_id}")
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Unknown error: {str(e)}")

@router.put("/{food_id}", response_model=FoodEmbeddingResponse)
async def update_food_embedding(food_id: str, request: FoodEmbeddingUpdate):
    try:
        success = vector_db_service.upsert_food(food_id, request.food_name)
        if not success:
            raise HTTPException(status_code=400, detail=f"Failed to update food embedding for {food_id}")
        return FoodEmbeddingResponse(message=f"Food embedding updated successfully for {food_id}")
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Unknown error: {str(e)}")

@router.delete("/{food_id}", response_model=FoodEmbeddingResponse)
async def delete_food(food_id: str):
    try:
        success = vector_db_service.delete_food(food_id)
        if not success:
            raise HTTPException(status_code=400, detail=f"Failed to delete food embedding for {food_id}")
        return FoodEmbeddingResponse(message=f"Food embedding deleted successfully for {food_id}")
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Unknown error: {str(e)}")