from pinecone.grpc import PineconeGRPC as Pinecone
from typing import Dict
from app.config.settings import settings
from app.core.embedding import embedding_service

class VectorDatabaseService:
    def __init__(self):
        self.index = None
        self._initialize_pinecone()
    
    def _initialize_pinecone(self):
        try:
            pc = Pinecone(api_key=settings.pinecone_api_key)
            self.index = pc.Index(host=settings.pinecone_index_host)
            print(f"Connected to Pinecone index: {settings.pinecone_index_name}")
        except Exception as e:
            print(f"Error initializing Pinecone: {e}")
            raise
    
    def upsert_food(self, food_id: str, food_name: str) -> bool:
        try:
            embedding = embedding_service.encode_text(food_name)
            self.index.upsert(
                vectors=[{
                    "id": food_id,
                    "values": embedding,
                    "metadata": {
                        "food_name": food_name,
                        "creator": "admin"
                    }
                }]
            )
            return True
        except Exception as e:
            print(f"Error upserting food {food_id}: {e}")
            return False
    
    def delete_food(self, food_id: str) -> bool:
        try:
            self.index.delete(ids=[food_id])
            return True
        except Exception as e:
            print(f"Error deleting food {food_id}: {e}")
            return False
    
    def search_most_similar_food(self, query: str) -> Dict:
        try:
            query_embedding = embedding_service.encode_text(query)
            results = self.index.query(
                vector=query_embedding,
                top_k=1,
                include_metadata=True,
                include_values=False
            )
            match = results.matches[0] if results.matches else None
            most_similar_food = {
                "food_id": "",
                "food_name": "",
                "similarity_score": 0.0  
            }
            if match:
                most_similar_food["food_id"] = match.id
                most_similar_food["food_name"] = match.metadata.get("food_name", "")
                most_similar_food["similarity_score"] = float(match.score)
            return most_similar_food
            
        except Exception as e:
            print(f"Lỗi khi tìm kiếm thực phẩm: {e}")
            # Trả về dict mặc định thay vì list rỗng
            return {
                "food_id": "",
                "food_name": "",
                "similarity_score": 0.0
            }
    
vector_db_service = VectorDatabaseService()