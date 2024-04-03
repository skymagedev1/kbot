FROM quay.io/projectquay/golang:1.20 as builder

ARG BUILD_PLATFORM=build_linux

WORKDIR /go/src/app
COPY . .
RUN make ${BUILD_PLATFORM}

FROM scratch
WORKDIR /
COPY --from=builder /go/src/app/kbot .
COPY --from=alpine:latest /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT ["./kbot"]