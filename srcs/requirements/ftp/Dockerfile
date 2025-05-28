
FROM debian:11
# Installation des paquets nécessaires
RUN apt-get update && apt-get install -y \
    vsftpd \
    systemd \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN systemctl enable vsftpd.service
RUN systemctl start vsftpd.service
