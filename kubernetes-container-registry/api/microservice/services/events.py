"""Event service"""
from uuid import uuid4, UUID
from dataclasses import dataclass, field


@dataclass
class Event:
    """event"""

    title: str
    id: UUID = field(default_factory=uuid4)


async def submit(title: str) -> Event:
    """Submits event for processing"""
    return Event(title=title)
