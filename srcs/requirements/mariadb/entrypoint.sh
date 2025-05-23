#!/bin/bash

# Fonction pour attendre que MariaDB soit prêt
wait_for_mysql() {
    echo "Attente du démarrage de MariaDB..."
    while ! mysqladmin ping -h"localhost" --silent; do
        sleep 1
    done
    echo "MariaDB est prêt!"
}

echo "Initialisation de MariaDB..."

# Initialiser la base de données
mysql_install_db --user=mysql --datadir=/var/lib/mysql

# Démarrer le serveur temporairement
/usr/bin/mysqld_safe --datadir=/var/lib/mysql &

# Extraction des donnees sensibles
if [ -f "$MYSQL_ROOT_PASSWORD_FILE" ]; then
  export MYSQL_ROOT_PASSWORD=$(cat "$MYSQL_ROOT_PASSWORD_FILE")
else
  echo "Erreur : fichier $MYSQL_ROOT_PASSWORD_FILE introuvable"
  exit 1
fi

if [ -f "$MYSQL_PASSWORD_FILE" ]; then
  export MYSQL_PASSWORD=$(cat "$MYSQL_PASSWORD_FILE")
else
  echo "Erreur : fichier $MYSQL_PASSWORD_FILE introuvable"
  exit 1
fi

# Attendre que le serveur soit prêt
wait_for_mysql

# Sécuriser MariaDB et créer la base de données + utilisateur pour WordPress
mysql -u root << EOF
-- Définir le mot de passe root
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

-- Créer un utilisateur non-admin avec accès distant pour WordPress
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';

-- Appliquer les privilèges
FLUSH PRIVILEGES;
EOF
    
# Arrêter le serveur temporaire
mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown

exec "$@"
