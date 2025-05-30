FROM debian:11

# Installation de Apache + PHP + extensions nécessaires
RUN apt-get update && apt-get install -y \
    apache2 \
    php \
    php-mysqli \
    wget \
    unzip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Création du dossier web et téléchargement d'une version précise d'Adminer
RUN mkdir -p /var/www/html && \
    wget https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php -O /var/www/html/index.php && \
    chown -R www-data:www-data /var/www/html
RUN rm -rf /var/www/html/index.html

# Apache écoute sur le port 8080
RUN sed -i 's/80/8080/' /etc/apache2/ports.conf && \
    sed -i 's/80/8080/' /etc/apache2/sites-available/000-default.conf

EXPOSE 8080

CMD ["apache2ctl", "-D", "FOREGROUND"]

