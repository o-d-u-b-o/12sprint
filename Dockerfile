FROM golang:1.24.3-alpine AS builder

WORKDIR /app

RUN apk add --no-cache git gcc musl-dev

COPY go.mod go.sum ./

RUN go mod download

COPY *.go ./

RUN CGO_ENABLED=1 GOOS=linux go build -o /main .

FROM alpine:latest

RUN apk add --no-cache libc6-compat

COPY --from=builder /main /main

COPY tracker.db /  

CMD ["/main"]