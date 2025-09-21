FROM debian:12

RUN apt-get update && apt-get install -y \
    redis-server \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /data && \
    chown redis:redis /data && \
    sed -i \
    -e 's/^bind .*/bind 0.0.0.0/' \
    -e 's/^daemonize .*/daemonize no/' \
    -e 's/^dir .*/dir \/data/' \
    -e 's/^protected-mode .*/protected-mode no/' \
    /etc/redis/redis.conf

EXPOSE 6379

ENTRYPOINT ["redis-server", "/etc/redis/redis.conf"]

