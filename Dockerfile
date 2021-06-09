FROM golang:1.16-alpine AS build
RUN echo "http://mirrors.ircam.fr/pub/alpine/edge/community" >> /etc/apk/repositories && \
    echo "http://mirrors.ircam.fr/pub/alpine/edge/main" >> /etc/apk/repositories && \
    apk add build-base ceph-dev linux-headers

WORKDIR /go/src/app
COPY . .

#RUN go build --ldflags '-extldflags "-static"' .
RUN go build .

FROM alpine:edge
RUN apk add --no-cache ceph-common
COPY --from=build /go/src/app/docker-plugin-cephfs /bin/
CMD ["docker-plugin-cephfs"]
