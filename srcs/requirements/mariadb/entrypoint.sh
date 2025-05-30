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

# 💡 Forcer MariaDB à écouter sur toutes les interfaces (vraiment !)
CONFIG_FILE="/etc/mysql/mariadb.conf.d/50-server.cnf"
if grep -q "^bind-address" "$CONFIG_FILE"; then
    sed -i 's/^bind-address\s*=.*/bind-address = 0.0.0.0/' "$CONFIG_FILE"
else
    echo "bind-address = 0.0.0.0" >> "$CONFIG_FILE"
fi

# Initialiser la base de données
#mysql_install_db --user=mysql --datadir=/var/lib/mysql
mariadb-install-db --user=mysql --datadir=/var/lib/mysql

# Démarrer le serveur temporairement
/usr/bin/mysqld_safe --datadir=/var/lib/mysql &

# Extraction des données sensibles
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
-- Définir le mot de passe root (identique pour localhost et %)
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;

-- Créer la DB + utilisateur WordPress
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';

-- Finalisation
FLUSH PRIVILEGES;
EOF

# Arrêter le serveur temporaire
if ! mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown; then
  echo "Échec de l'arrêt de MariaDB. Forçage..."
  killall mysqld || true
fi


# Lancer MariaDB en mode normal
exec "$@"

