# Build stage
FROM golang:1.24-alpine AS builder

WORKDIR /app

# Copy go.mod and go.sum
COPY go.mod ./

# Download dependencies (none expected)
RUN go mod download

# Copy source code
COPY . .

# Build the app
RUN go build -o go-web-app main.go

# Runtime stage
FROM alpine:latest

WORKDIR /app

# Copy binary
COPY --from=builder /app/go-web-app .

# Copy static files
COPY --from=builder /app/static ./static

# Expose port (adjust if main.go uses a different port)
EXPOSE 8080

CMD ["./go-web-app"]