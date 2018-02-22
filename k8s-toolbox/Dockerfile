FROM alpine:3.6

ENV KUBE_LATEST_VERSION="v1.7.10"
ENV HELM_LATEST_VERSION="v2.6.1"

RUN apk upgrade --update \
 && apk add -v --update -t deps ca-certificates curl \
 && apk add -v --update python py-pip bash bash-doc bash-completion \
 && pip install --upgrade awscli \
 && curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBE_LATEST_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
 && chmod +x /usr/local/bin/kubectl \
 && curl -L http://storage.googleapis.com/kubernetes-helm/helm-${HELM_LATEST_VERSION}-linux-amd64.tar.gz -o /tmp/helm-${HELM_LATEST_VERSION}-linux-amd64.tar.gz \
 && tar -xvzf /tmp/helm-${HELM_LATEST_VERSION}-linux-amd64.tar.gz \
 && mv linux-amd64/helm /usr/local/bin \
 && rm -f /tmp/helm-${HELM_LATEST_VERSION}-linux-amd64.tar.gz \
 && apk del --purge deps \
 && rm /var/cache/apk/*

COPY ./scripts /usr/local/bin/

ENTRYPOINT ["bash", "-c"]
