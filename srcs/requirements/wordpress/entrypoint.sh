#!/bin/bash
set -e

# Load sensitive environment variable
if [ -f /run/secrets/credentials.txt ]; then
    source /run/secrets/credentials.txt
else
    echo "Erreur : /run/secrets/credentials.txt manquant"
    exit 1
fi

# Load Database password
[ -f "$DB_PASSWORD_FILE" ] && DB_PASSWORD=$(cat "$DB_PASSWORD_FILE")

cd /var/www/wordpress

# Generate wp-config.php
if [ ! -f wp-config.php ]; then
    wp config create \
        --dbname="${DB_NAME}" \
        --dbuser="${DB_USER}" \
        --dbpass="${DB_PASSWORD}" \
        --dbhost="${DB_HOST}" \
        --allow-root

    wp config set WP_REDIS_HOST redis --allow-root
fi

# Install WordPress
if ! wp core is-installed --allow-root; then
    wp core install \
        --url="https://${DOMAIN_NAME}" \
        --title="Inception" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASS}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --allow-root

    wp user create "${WP_USER}" "${WP_USER_EMAIL}" \
        --user_pass="${WP_USER_PASS}" \
        --role=editor \
        --allow-root
fi

# Ensure Redis plugin is active
if ! wp plugin is-installed redis-cache --allow-root; then
    wp plugin install redis-cache --activate --allow-root
else
    wp plugin activate redis-cache --allow-root
fi

wp redis enable --allow-root

exec php-fpm7.4 -F
