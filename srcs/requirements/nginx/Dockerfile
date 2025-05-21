FROM debian:11

# Installation des paquets nécessaires
RUN apt-get update && apt-get install -y nginx \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

CMD ["nginx", "-g", "daemon off;"]
