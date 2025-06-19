from pydantic import BaseModel, Field

class FoodEmbeddingCreate(BaseModel):
    food_id: str = Field(..., description="ID món ăn")
    food_name: str = Field(..., description="Tên món ăn")

class FoodEmbeddingUpdate(BaseModel):
    food_name: str = Field(..., description="Tên món ăn cập nhật")

class FoodEmbeddingResponse(BaseModel):
    message: str = Field(..., description="Thông báo")