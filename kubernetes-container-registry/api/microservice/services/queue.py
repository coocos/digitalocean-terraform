"""Simple event queue backed by Redis"""
from typing import Optional

import aioredis

from microservice.settings import settings


redis: Optional[aioredis.Redis] = None


async def _get_redis_client() -> aioredis.Redis:
    """Returns and creates Redis client if needed"""
    global redis
    if not redis:
        redis = await aioredis.from_url(
            settings.REDIS_ADDRESS, encoding="utf-8", decode_responses=True
        )
    return redis


async def push(data: str | bytes) -> None:
    """Pushes data to the queue"""
    redis = await _get_redis_client()
    await redis.rpush(settings.REDIS_EVENT_QUEUE, data)
