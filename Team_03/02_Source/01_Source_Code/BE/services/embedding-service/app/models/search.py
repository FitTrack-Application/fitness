from pydantic import BaseModel, Field 
from typing import List

class FoodSearchRequest(BaseModel):
    meal_description: str = Field(..., description="Mô tả bữa ăn")
    
class FoodEntry(BaseModel):
    food_id: str = Field(..., description="ID món ăn")
    serving_unit_id: str = Field(..., description="ID unit phục vụ")
    number_of_servings: float = Field(..., description="Số lượng khẩu phần")
    
class FoodSearchResponse(BaseModel):
    message: str = Field(..., description="Thông báo")
    data: List[FoodEntry] = Field(..., description="Danh sách món ăn")
    

