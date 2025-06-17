FROM debian:11

# Installation des paquets nécessaires
RUN apt-get update && apt-get install -y \
    vsftpd \
    openssl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Création du certificat SSL
RUN mkdir -p /etc/nginx/certs && \
    openssl req -x509 -newkey rsa:2048 -sha256 -nodes \
    -keyout /etc/ssl/private/vsftpd.key \
    -out /etc/ssl/certs/vsftpd.crt -days 365 \
    -subj "/C=MG/ST=Analamanga/L=Antananarivo/O=42/OU=Inception/CN=srandria.42.fr"

RUN mkdir -p /var/www/wordpress /var/www/static && \
    chmod 777 /var/www/wordpress /var/www/static

# Copie des fichiers nécessaires
COPY ./entrypoint.sh /entrypoint.sh
COPY vsftpd.conf /etc/vsftpd.conf
RUN chmod +x /entrypoint.sh

EXPOSE 20 21 40000-40010

# Utilise le script comme point d'entrée
ENTRYPOINT ["/entrypoint.sh"]
