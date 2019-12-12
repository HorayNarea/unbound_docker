FROM alpine:3.10

RUN apk add --no-cache \
  bind-tools \
  ca-certificates \
  curl \
  unbound && \
  curl -o /etc/unbound/root.hints https://www.internic.net/domain/named.cache && \
  chown root:unbound /etc/unbound && \
  chmod 775 /etc/unbound && \
  apk del --no-cache curl && \
  /usr/sbin/unbound-anchor -a /etc/unbound/trusted-key.key | true

COPY unbound.conf /etc/unbound/unbound.conf

EXPOSE 53/udp 53/tcp

CMD /usr/sbin/unbound -c /etc/unbound/unbound.conf

HEALTHCHECK CMD dig @127.0.0.1 || exit 1
