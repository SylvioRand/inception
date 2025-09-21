FROM debian:12

RUN apt-get update && apt-get install -y apt-transport-https lsb-release ca-certificates wget gnupg2 curl

# Add the Sury repository (NEW METHOD for Debian 12)
RUN wget -qO /usr/share/keyrings/php.gpg https://packages.sury.org/php/apt.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

# Mettre à jour après l'ajout du dépôt et installer PHP 7.4
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
    && apt-get clean && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /var/www/wordpress

# Download and extract WordPress
RUN wget https://wordpress.org/wordpress-6.2.2.tar.gz \
    && tar -xzf wordpress-6.2.2.tar.gz \
    && rm wordpress-6.2.2.tar.gz \
    && mv wordpress/* /var/www/wordpress \
    && rm -rf wordpress

# Configure PHP-FPM to listen on port 9000
RUN mkdir -p /run/php && \
    sed -i 's|^listen = .*|listen = 9000|' /etc/php/7.4/fpm/pool.d/www.conf && \
    echo "listen.owner = www-data" >> /etc/php/7.4/fpm/pool.d/www.conf && \
    echo "listen.group = www-data" >> /etc/php/7.4/fpm/pool.d/www.conf

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 9000

ENTRYPOINT ["/entrypoint.sh"]
