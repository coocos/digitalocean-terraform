"""Routes related to events"""
from uuid import UUID

from fastapi import APIRouter, status
from pydantic import BaseModel

from microservice import services

router = APIRouter()


class EventRequest(BaseModel):
    """Request payload for creating new event"""

    title: str


class Event(EventRequest):
    """Response payload for new event"""

    id: UUID

    class Config:
        orm_mode = True


@router.post(
    "/events",
    status_code=status.HTTP_201_CREATED,
    response_model=Event,
)
async def create_event(event: EventRequest):
    """Creates new event"""
    return await services.events.submit(event.title)
