FROM debian:11
# Installation des paquets nécessaires
RUN apt-get update && apt-get install -y \
    vsftpd \
    openssl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Création du certificat auto-signé et des dossiers nécessaires
RUN mkdir -p /etc/nginx/certs && \
    openssl req -x509 -newkey rsa:2048 -sha256 -nodes \
    -keyout /etc/ssl/private/vsftpd.key \
    -out /etc/ssl/certs/vsftpd.crt -days 365 \
    -subj "/C=MG/ST=Analamanga/L=Antananarivo/O=42/OU=Inception/CN=srandria.42.fr"

# Création de l'utilisateur FTP
RUN useradd -m ftpuser && echo "ftpuser:password" | chpasswd

# Création des répertoires de connexion
RUN mkdir -p /var/www/wordpress /var/run/vsftpd/empty && \
    chown ftpuser:ftpuser /var/www/wordpress

# Copie du fichier de config
COPY vsftpd.conf /etc/vsftpd.conf

EXPOSE 20 21 40000-40010

# Lancement du service vsftpd en foreground
CMD ["/usr/sbin/vsftpd", "/etc/vsftpd.conf"]
