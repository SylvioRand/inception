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

# Attendre que le serveur soit prêt
wait_for_mysql

# Définir les variables d'environnement
#MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-rootpassword}
#MYSQL_DATABASE=${MYSQL_DATABASE:-wordpress}
#MYSQL_USER=${MYSQL_USER:-wpuser}
#MYSQL_PASSWORD=${MYSQL_PASSWORD:-password}

# Sécuriser MariaDB et créer la base de données + utilisateur pour WordPress
mysql -u root << EOF
-- Définir le mot de passe root
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD_FILE}';

-- Créer un utilisateur non-admin avec accès distant pour WordPress
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD_FILE}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';

-- Appliquer les privilèges
FLUSH PRIVILEGES;
EOF
    
# Arrêter le serveur temporaire
mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown

exec "$@"


