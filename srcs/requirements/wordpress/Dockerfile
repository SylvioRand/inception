FROM debian:11

# Installer les dépendances pour ajouter le dépôt PHP
RUN apt-get update && apt-get install -y apt-transport-https lsb-release ca-certificates wget gnupg2

# Ajouter le dépôt de sury (pour PHP 7.4)
RUN wget -qO - https://packages.sury.org/php/apt.gpg | apt-key add - && \
    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list

# Installer PHP et les extensions
RUN apt-get update && apt-get install -y \
    php7.4-fpm \
    php7.4-mysql \
    php7.4-xml \
    php7.4-gd \
    php7.4-curl \
    php7.4-mbstring \
    php7.4-zip \
    mariadb-client \
    wget \
    tar \
    curl \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

# Installer WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

# Création du dossier WordPress
RUN mkdir -p /var/www/wordpress

# Téléchargement et extraction de WordPress
RUN wget https://wordpress.org/wordpress-6.2.2.tar.gz && \
    tar -xzf wordpress-6.2.2.tar.gz && \
    rm wordpress-6.2.2.tar.gz && \
    mv wordpress/* /var/www/wordpress && \
    rmdir wordpress

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

EXPOSE 9000

# Commande de démarrage
ENTRYPOINT ["/entrypoint.sh"]
