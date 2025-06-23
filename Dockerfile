# Use official Go image for building
FROM golang:1.24-alpine AS builder

# Set working directory
WORKDIR /app

# Copy go.mod and go.sum
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy source code
COPY . .

# Build the Go app
RUN go build -o go-web-app main.go

# Use a minimal alpine image for runtime
FROM alpine:latest

# Set working directory
WORKDIR /app

# Copy the built binary
COPY --from=builder /app/go-web-app .

# Copy static files (for your static directory)
COPY --from=builder /app/static ./static

# Expose port (adjust if your app uses a different port)
EXPOSE 8080

# Run the app
CMD ["./go-web-app"]