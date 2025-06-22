# syntax=docker/dockerfile:1.4

# -------- Build Stage --------
FROM golang:1.24-alpine AS builder

# Set Go environment for static binary
ENV CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64

WORKDIR /app

# Cache dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy source code
COPY . .

# Build the binary
RUN go build -o go-web-app main.go

# -------- Final Stage --------
FROM gcr.io/distroless/static-debian12:nonroot

WORKDIR /app

# Copy binary and static files
COPY --from=builder /app/go-web-app .
COPY --from=builder /app/static ./static

# Use non-root user for security
USER nonroot:nonroot

# App runs on port 8080
EXPOSE 8080

# Run the binary
ENTRYPOINT ["/app/go-web-app"]
