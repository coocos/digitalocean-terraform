"""Settings for the service"""
from pydantic import BaseSettings


class Settings(BaseSettings):
    """Settings for the service"""

    REDIS_ADDRESS: str = "redis://localhost:6379"
    REDIS_EVENT_QUEUE: str = "events"


settings = Settings()
