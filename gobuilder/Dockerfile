FROM golang:1.13
ARG goreleaser=v0.123.3
RUN curl -s -L -o /tmp/goreleaser.tgz \
    "https://github.com/goreleaser/goreleaser/releases/download/$goreleaser/goreleaser_$(uname -s)_$(uname -m).tar.gz" \
    && tar -xf /tmp/goreleaser.tgz -C /usr/local/bin \
    && rm -f /tmp/goreleaser.tgz
ENTRYPOINT [ "make" ]
