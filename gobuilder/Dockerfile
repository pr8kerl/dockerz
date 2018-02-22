FROM golang:1.10

ARG dep=v0.4.1
ARG goreleaser=v0.46.3

RUN curl -fsSL -o /usr/local/bin/dep https://github.com/golang/dep/releases/download/$dep/dep-linux-amd64 && chmod +x /usr/local/bin/dep
RUN curl -s -L -o /tmp/goreleaser.tgz \
    "https://github.com/goreleaser/goreleaser/releases/download/$goreleaser/goreleaser_$(uname -s)_$(uname -m).tar.gz" \
    && tar -xf /tmp/goreleaser.tgz -C /usr/local/bin

ENTRYPOINT [ "make" ]
