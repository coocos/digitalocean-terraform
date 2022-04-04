"""Event service"""
from uuid import uuid4, UUID

from pydantic import BaseModel, Field

from microservice.services import queue


class Event(BaseModel):
    """Simple event"""

    title: str
    id: UUID = Field(default_factory=uuid4)


async def submit(title: str) -> Event:
    """Submits event for processing"""

    event = Event(title=title)
    await queue.push(event.json())
    return event
