#!/bin/bash
set -e

# Function to wait for MariaDB to be ready
wait_for_mysql() {
    echo "Waiting for MariaDB to start..."
    while ! mysqladmin ping -h"localhost" --silent; do
        sleep 1
    done
    echo "MariaDB is ready."
}

echo "Starting MariaDB initialization..."

# Ensure MariaDB listens on all interfaces
CONFIG_FILE="/etc/mysql/mariadb.conf.d/50-server.cnf"
if grep -q "^bind-address" "$CONFIG_FILE"; then
    sed -i 's/^bind-address\s*=.*/bind-address = 0.0.0.0/' "$CONFIG_FILE"
else
    echo "bind-address = 0.0.0.0" >> "$CONFIG_FILE"
fi

# Check if MariaDB has already been initialized
if [ ! -f "/.db_initialized" ]; then
    echo "Database not initialized. Running setup..."

    mariadb-install-db --user=mysql --datadir=/var/lib/mysql

    /usr/bin/mysqld_safe --datadir=/var/lib/mysql &
    sleep 1

    # Load secrets from mounted files
    if [ -f "$MYSQL_ROOT_PASSWORD_FILE" ]; then
        export MYSQL_ROOT_PASSWORD=$(cat "$MYSQL_ROOT_PASSWORD_FILE")
    else
        echo "Error: file $MYSQL_ROOT_PASSWORD_FILE not found"
        exit 1
    fi

    if [ -f "$MYSQL_PASSWORD_FILE" ]; then
        export MYSQL_PASSWORD=$(cat "$MYSQL_PASSWORD_FILE")
    else
        echo "Error: file $MYSQL_PASSWORD_FILE not found"
        exit 1
    fi

    wait_for_mysql

    echo "Configuring database users..."
    mysql -u root << EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;

CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';

FLUSH PRIVILEGES;
EOF

    # shutdown temporary server
    mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown || killall mysqld

    # Mark as initialized
    touch /.db_initialized

else
    echo "Database already initialized. Starting normally."
fi

exec mysqld
