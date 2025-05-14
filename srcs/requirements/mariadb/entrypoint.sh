#!/bin/bash

# Fonction pour attendre que MariaDB soit prêt
wait_for_mysql() {
    echo "Attente du démarrage de MariaDB..."
    while ! mysqladmin ping -h"localhost" --silent; do
        sleep 1
    done
    echo "MariaDB est prêt!"
}

# Si le répertoire de données est vide, initialiser MariaDB
if [ -z "$(ls -A /var/lib/mysql)" ]; then
    echo "Initialisation de MariaDB..."
    
    # Initialiser la base de données
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    # Démarrer le serveur temporairement
    /usr/bin/mysqld_safe --datadir=/var/lib/mysql &
    
    # Attendre que le serveur soit prêt
    wait_for_mysql
    
    # Définir les variables d'environnement
    DB_NAME=${DB_NAME:-wordpress}
    DB_USER=${DB_USER:-wpuser}
    DB_PASSWORD=${DB_PASSWORD:-password}
    MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-rootpassword}
    
    # Sécuriser MariaDB et créer la base de données + utilisateur pour WordPress
    mysql -u root << EOF
    -- Définir le mot de passe root
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
    
    -- Créer un utilisateur non-admin avec accès distant pour WordPress
    CREATE DATABASE IF NOT EXISTS ${DB_NAME};
    CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
    GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';
    
    -- Appliquer les privilèges
    FLUSH PRIVILEGES;
EOF
    
    # Arrêter le serveur temporaire
    mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown
    
    echo "L'initialisation de MariaDB est terminée !"
else
    echo "Les données MariaDB existent déjà, pas besoin d'initialisation."
fi

# Démarrer MariaDB avec les paramètres appropriés
echo "Démarrage de MariaDB..."
exec "$@"
