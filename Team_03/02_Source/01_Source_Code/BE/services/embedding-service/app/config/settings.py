from pydantic_settings import BaseSettings
class Settings(BaseSettings):
    app_name: str = "embedding-service"
    app_version: str = "1.0.0"
    debug: bool = False
    host: str = "localhost"
    port: int = 8000
    
    api_str: str = "/api/ai"
    
    pinecone_api_key: str
    pinecone_index_name: str
    pinecone_index_host: str
    
    embedding_model_name: str
    embedding_dimension: int
    
    ai_api_key: str
    ai_model_name: str
    
    class Config:
        env_file = ".env"
        case_sensitive = False
        env_file_encoding = "utf-8"

settings = Settings()