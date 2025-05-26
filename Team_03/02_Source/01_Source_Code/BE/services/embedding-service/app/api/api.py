from fastapi import APIRouter
from app.api.endpoints import food, search

api_router = APIRouter()

api_router.include_router(
    food.router,
    prefix = "/food-embeddings", 
    tags=["Food Embeddings"]
)

api_router.include_router(
    search.router,
    tags=["Search Foods"]
)