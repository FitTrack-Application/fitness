from fastapi import APIRouter, HTTPException
from typing import List
from app.models.search import FoodSearchRequest, FoodEntry, FoodSearchResponse
from app.core.search import search_service

router = APIRouter(tags=["Search Foods"])

@router.post("/get-food-entries", response_model=FoodSearchResponse)
async def get_food_entries(request: FoodSearchRequest):
    try:
        food_entries = search_service.parse_meal_description(meal_description=request.meal_description)
        if not food_entries:
            return FoodSearchResponse(message="Không tìm thấy món ăn phù hợp", data=[])
        return FoodSearchResponse(
            message="Tìm kiếm thành công",
            data=[FoodEntry(**entry) for entry in food_entries]
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Unknown error: {str(e)}")