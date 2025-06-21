# syntax=docker/dockerfile:1.4

# Builder stage
FROM golang:1.24-alpine AS builder

RUN apk add --no-cache git

WORKDIR /app

# Copy and download dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy source code
COPY . .

# Build the Go app
RUN go build -o go-web-app main.go

# Final minimal image
FROM alpine:latest

WORKDIR /root/

COPY --from=builder /app/go-web-app .

EXPOSE 8080

CMD ["./go-web-app"]
