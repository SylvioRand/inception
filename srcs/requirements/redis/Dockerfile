FROM debian:11

# Mise à jour et installation
RUN apt-get update && apt-get install -y \
    redis-server \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Configuration essentielle
RUN mkdir -p /data && \
    chown redis:redis /data && \
    sed -i \
    -e 's/^bind .*/bind 0.0.0.0/' \
    -e 's/^daemonize .*/daemonize no/' \
    -e 's/^protected-mode .*/protected-mode no/' \
    -e 's/^logfile .*/logfile ""/' \
    -e 's/^dir .*/dir \/data/' \
    -e 's/^supervised .*/supervised no/' \
    /etc/redis/redis.conf

# Port Redis
EXPOSE 6379

# Point de montage pour les données
VOLUME /data

# Commande de démarrage
CMD ["redis-server", "/etc/redis/redis.conf"]
