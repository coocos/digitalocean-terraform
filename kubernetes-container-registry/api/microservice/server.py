"""Simple microservice"""
import platform

from fastapi import FastAPI

from microservice.routes import events

app = FastAPI()


@app.get("/")
def root():
    return {"host": platform.node()}


app.include_router(events.router, prefix="/api/v1")
