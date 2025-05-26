from sentence_transformers import SentenceTransformer
from typing import List
from app.config.settings import settings

class EmbeddingService:
    def __init__(self):
        self.model = None
        self._load_model()
    
    def _load_model(self):
        try:
            self.model = SentenceTransformer(settings.embedding_model_name)
            print(f"Loaded embedding model: {settings.embedding_model_name}")
        except Exception as e:
            print(f"Error loading embedding model: {e}")
            raise
    
    def encode_text(self, text: str) -> List[float]:
        if not self.model:
            raise ValueError("Model not loaded")
        
        embedding = self.model.encode(text, convert_to_numpy=True)
        return embedding

embedding_service = EmbeddingService()