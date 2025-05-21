FROM debian:11

# Installation des paquets nécessaires
RUN apt-get update && apt-get install -y \
    php-fpm \
    php-mysql \
    php-xml \
    php-gd \
    php-curl \
    php-mbstring \
    php-zip \
    wget \
    tar && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Création du dossier WordPress
RUN mkdir -p /var/www/wordpress

# Téléchargement et extraction de WordPress

RUN wget https://wordpress.org/wordpress-6.2.2.tar.gz && \
    tar -xzf wordpress-6.2.2.tar.gz && \
    mv wordpress /var/www/wordpress && \
    rm wordpress-6.2.2.tar.gz

# Configuration de PHP-FPM
RUN mkdir -p /run/php && \
    sed -i 's|^listen = .*|listen = 9000|' /etc/php/7.4/fpm/pool.d/www.conf && \
    echo "listen.owner = www-data" >> /etc/php/7.4/fpm/pool.d/www.conf && \
    echo "listen.group = www-data" >> /etc/php/7.4/fpm/pool.d/www.conf


# Définir le dossier de travail
WORKDIR /var/www/wordpress

# Copie du script d’entrée
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Exposer le port utilisé par PHP-FPM (ceci est purement informatif mais n`a pas d`inmpact sur la communication interne ou externe du container)
EXPOSE 9000

# Commande de démarrage
CMD ["/entrypoint.sh"]

