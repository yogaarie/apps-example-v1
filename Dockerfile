# Stage 1: Build the binary
FROM golang:1.26.2-alpine AS builder

# Install git for private modules or certain dependencies
RUN apk add --no-cache git

WORKDIR /app

# Leverage Docker cache by downloading dependencies first
COPY go.mod go.sum ./
RUN go mod download

# Copy source code and build
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o /main main.go

# Stage 2: Final minimal image
FROM alpine:latest  

WORKDIR /root/

# Copy the binary from the builder stage
COPY --from=builder /main .

# Expose the application port
EXPOSE 8080

# Run the binary
CMD ["./main"]
