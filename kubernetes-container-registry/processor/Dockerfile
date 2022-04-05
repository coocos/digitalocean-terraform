FROM golang:1.18-alpine AS builder

WORKDIR /processor
COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN go build -o processor main.go

FROM alpine AS runtime

RUN adduser -D user
USER user

WORKDIR /processor
COPY --from=builder /processor/processor ./

CMD ["./processor"]