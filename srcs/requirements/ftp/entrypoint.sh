#!/bin/bash
set -e

# Lire le mot de passe depuis le fichier (optionnel)
[ -f "$FTP_PASSWORD_FILE" ] && FTP_PASSWORD=$(cat "$FTP_PASSWORD_FILE")

# Création de l'utilisateur FTP
useradd -m "$FTP_USER" && echo "$FTP_USER:$FTP_PASSWORD" | chpasswd

# Création des répertoires nécessaires
mkdir -p /var/www/wordpress /var/run/vsftpd/empty
chown -R "$FTP_USER:$FTP_USER" /var/www/wordpress

# Lancer vsftpd
exec /usr/sbin/vsftpd /etc/vsftpd.conf

