# Stage 1: Build the Go binary
FROM golang:1.22 AS builder

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy go.mod and go.sum files
COPY go.mod go.sum ./

# Download all dependencies. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go mod download

# Copy the source from the current directory to the Working Directory inside the container
COPY .. .

# Build the Go app
RUN go build -o main ./cmd/server

# Stage 2: Create a minimal image with distroless
FROM gcr.io/distroless/base-debian10

# Copy the binary from the builder stage
COPY --from=builder /app/main /app/main

# Set the binary as the entrypoint
ENTRYPOINT ["/app/main"]
