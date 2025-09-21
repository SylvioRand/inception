#!/bin/bash
set -e

[ -f "$FTP_PASSWORD_FILE" ] && FTP_PASSWORD=$(cat "$FTP_PASSWORD_FILE")

# Creating FTP user
useradd -m "$FTP_USER" && echo "$FTP_USER:$FTP_PASSWORD" | chpasswd

mkdir -p /var/www/wordpress /var/run/vsftpd/empty
chown -R "$FTP_USER:$FTP_USER" /var/www/

exec /usr/sbin/vsftpd /etc/vsftpd.conf

