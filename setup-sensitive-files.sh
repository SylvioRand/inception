#!/bin/bash

# Fonction pour générer un mot de passe aléatoire de 12 caractères
generate_password() {
  tr -dc 'A-Za-z0-9!@#$%&*_' < /dev/urandom | head -c 12
}

mkdir -p srcs
if [ ! -f srcs/.env ]; then
  echo "Creating .env file..."
  cat > srcs/.env <<EOF
DOMAIN_NAME=srandria.42.fr
MYSQL_DATABASE=wordpress
MYSQL_USER=wp_user
FTP_USER=ftp_user
EOF
fi

mkdir -p secrets

DB_PASS=$(generate_password)
DB_ROOT_PASS=$(generate_password)
FTP_PASS=$(generate_password)

echo "$DB_PASS" > secrets/db_password.txt
echo "$DB_ROOT_PASS" > secrets/db_root_password.txt
echo "$FTP_PASS" > secrets/ftp_password.txt

# Remplit credentials.txt s’il est vide
if [ ! -s secrets/credentials.txt ]; then
  echo "Filling credentials.txt..."
  WP_ADMIN_PASS=$(generate_password)
  WP_USER_PASS=$(generate_password)

  cat > secrets/credentials.txt <<EOF
WP_ADMIN_USER=admin
WP_ADMIN_PASS=$WP_ADMIN_PASS
WP_ADMIN_EMAIL=admin@example.com
WP_USER=user
WP_USER_PASS=$WP_USER_PASS
WP_USER_EMAIL=user@example.com
EOF
fi

echo "Setup done. Generated passwords:"
echo "- MySQL user password: $DB_PASS"
echo "- MySQL root password: $DB_ROOT_PASS"
echo "- FTP password: $FTP_PASS"

