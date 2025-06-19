from typing import List
from app.config.settings import settings
from openai import AzureOpenAI

class EmbeddingService:
    def __init__(self):
        self.model_client = None
        self._load_model_client()
    
    def _load_model_client(self):
        try:
            self.model_client = AzureOpenAI(
                api_key=settings.ai_api_key,  
                api_version=settings.ai_api_version,
                azure_endpoint = settings.ai_azure_endpoint
            )
            print(f"Loaded embedding model client: {settings.ai_embedding_model_name}")
        except Exception as e:
            print(f"Error loading embedding model client: {e}")
            raise
    
    def encode_text(self, text: str) -> List[float]:
        if not self.model_client:
            raise ValueError("Model not loaded")
                
        response = self.model_client.embeddings.create(
            input=[text],
            model=settings.ai_embedding_model_name,
        )
        embedding = response.data[0].embedding
        return embedding

embedding_service = EmbeddingService()