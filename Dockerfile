FROM golang:1.21-alpine AS builder

WORKDIR /app
COPY go.mod ./
COPY main.go ./

RUN go build -o hello-world main.go

FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /app/hello-world .
EXPOSE 7777
CMD ["./hello-world"]

