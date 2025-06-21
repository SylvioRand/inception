
FROM debian:11

RUN apt-get update && apt-get install -y \
    vsftpd \
    openssl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN openssl req -x509 -newkey rsa:2048 -sha256 -nodes \
    -keyout /etc/ssl/private/vsftpd.key \
    -out /etc/ssl/certs/vsftpd.crt \
    -days 365 \
    -subj "/C=MG/ST=Analamanga/L=Antananarivo/O=42/OU=Inception/CN=srandria.42.fr"

RUN mkdir -p /var/www/wordpress /var/www/static \
    && chmod -R 755 /var/www/wordpress /var/www/static

COPY ./entrypoint.sh /entrypoint.sh
COPY vsftpd.conf /etc/vsftpd.conf

RUN chmod +x /entrypoint.sh

# Ports for FTP: 20 (data), 21 (control), 40000-40010 (passive)
EXPOSE 20 21 40000-40010

ENTRYPOINT ["/entrypoint.sh"]

