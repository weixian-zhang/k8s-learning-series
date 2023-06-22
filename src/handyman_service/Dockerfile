# Stage 1: Build the Go binary
FROM golang:1.20-alpine AS build

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 
RUN GOOS=linux 
RUN go build -o handymantracker ./src

# Stage 2: Create the final minimal image
FROM alpine:latest

WORKDIR /root/

COPY --from=build /app/handymantracker .

CMD ["./handymantracker"]
