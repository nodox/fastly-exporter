# build stage
FROM golang:alpine AS build-stage
COPY . /go/src/goapp
WORKDIR /go/src/goapp


RUN apk add --no-cache git \
    && go get -d -v \
    && apk del git

RUN go build -o goapp

# artifact stage
FROM alpine
WORKDIR /app
RUN apk add --no-cache ca-certificates \
    && rm -rf /var/cache/apk/*

COPY --from=build-stage /go/src/goapp /app/

CMD ["./docker-entrypoint.sh"]
