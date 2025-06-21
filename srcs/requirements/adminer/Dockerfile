FROM debian:11

RUN apt-get update && apt-get install -y \
    apache2 \
    php \
    php-mysqli \
    wget \
    unzip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN  mkdir -p /var/www/html \
    && wget https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php -O /var/www/html/index.php \
    && chown -R www-data:www-data /var/www/html \
    && rm -rf /var/www/html/index.html
    
RUN sed -i 's/80/8080/' /etc/apache2/ports.conf && \
    sed -i 's/80/8080/' /etc/apache2/sites-available/000-default.conf

EXPOSE 8080

ENTRYPOINT ["apache2ctl", "-D", "FOREGROUND"]
