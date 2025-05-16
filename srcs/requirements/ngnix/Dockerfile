FROM debian:11

# Installation des paquets nécessaires
RUN apt-get update && apt-get install -y \
    wget \
    ngnix \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
