FROM golang:1.9 as builder

RUN apt-get install curl
RUN curl -s -L -o /tmp/goreleaser.tgz \
    "https://github.com/goreleaser/goreleaser/releases/download/v0.35.7/goreleaser_$(uname -s)_$(uname -m).tar.gz" \
    && tar -xf /tmp/goreleaser.tgz -C /

#FROM scratch
#COPY --from=builder /goreleaser /goreleaser

ENTRYPOINT [ "/goreleaser" ]
