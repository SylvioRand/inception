FROM debian:11

# Installation des paquets nécessaires
RUN apt-get update && apt-get install -y nginx \
    openssl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Création du certificat auto-signé et des dossiers nécessaires
RUN mkdir -p /etc/nginx/certs && \
    openssl req -x509 -newkey rsa:2048 -sha256 -nodes \
    -keyout /etc/nginx/certs/key.pem \
    -out /etc/nginx/certs/cert.pem -days 365 \
    -subj "/C=MG/ST=Analamanga/L=Antananarivo/O=42/OU=Inception/CN=srandria.42.fr"

CMD ["nginx", "-g", "daemon off;"]
