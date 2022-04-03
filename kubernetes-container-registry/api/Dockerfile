FROM python:3.10-alpine

RUN apk add build-base

RUN adduser -D user
USER user
WORKDIR /home/user/api/

COPY requirements.txt .
RUN pip install --user -r requirements.txt

COPY microservice microservice

EXPOSE 8000

CMD [ "/home/user/.local/bin/uvicorn", "microservice.server:app", "--host", "0.0.0.0" ]