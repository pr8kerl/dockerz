FROM alpine:3.6

RUN apk upgrade --update \
 && apk add -v --update -t deps ca-certificates curl \
 && apk add -v --update bash bash-doc bash-completion \
 && apk --update add postgresql-client \
 && apk del --purge deps \
 && rm /var/cache/apk/*

ENTRYPOINT ["psql", "postgresql://${PGUSER}:${PGPASS}@${PGENDPOINT}"]
