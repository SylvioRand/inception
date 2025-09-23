#!/bin/bash
set -e

[ -f "$FTP_PASSWORD_FILE" ] && FTP_PASSWORD=$(cat "$FTP_PASSWORD_FILE")

# Créer l'utilisateur seulement s'il n'existe pas déjà
if ! id "$FTP_USER" &>/dev/null; then
    useradd -m "$FTP_USER"
    echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
fi

mkdir -p /var/www/wordpress /var/run/vsftpd/empty
chown -R "$FTP_USER:$FTP_USER" /var/www/

exec /usr/sbin/vsftpd /etc/vsftpd.conf

