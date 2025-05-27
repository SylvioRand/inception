#!/bin/bash
set -e

# Charger les variables d'environnement sensibles
if [ -f /run/secrets/credentials.txt ]; then
    source /run/secrets/credentials.txt
else
    echo "Erreur : /run/secrets/credentials.txt manquant"
    exit 1
fi

# Lire les secrets depuis les fichiers (si fournis)
[ -f "$DB_PASSWORD_FILE" ] && DB_PASSWORD=$(cat "$DB_PASSWORD_FILE")

# Générer wp-config.php s’il n’existe pas
if [ ! -f wp-config.php ]; then
    wp config create \
        --dbname=${DB_NAME} \
        --dbuser=${DB_USER} \
        --dbpass=${DB_PASSWORD} \
        --dbhost=${DB_HOST} \
        --path=/var/www/wordpress \
        --allow-root
fi

# Installer WordPress si ce n’est pas déjà fait
if ! wp core is-installed --allow-root --path=/var/www/wordpress; then
    wp core install \
        --url="https://$DOMAIN_NAME" \
        --title="Inception" \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ADMIN_PASS \
        --admin_email=$WP_ADMIN_EMAIL \
        --allow-root \
        --path=/var/www/wordpress

    wp user create $WP_USER $WP_USER_EMAIL \
        --user_pass=$WP_USER_PASS \
        --role=editor \
        --allow-root \
        --path=/var/www/wordpress
fi

# Démarrer PHP-FPM
exec php-fpm7.4 -F
