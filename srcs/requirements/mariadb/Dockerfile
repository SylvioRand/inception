FROM debian:11
# Installation des paquets nécessaires
RUN apt-get update && apt-get install -y \
    mariadb-server \
    mariadb-client \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
# Configuration de MariaDB pour écouter sur toutes les interfaces
#RUN mkdir -p /var/lib/mysql /run/mysqld && chown -R mysql:mysql /run/mysqld
# Création du répertoire pour les données persistantes
#RUN mkdir -p /var/lib/mysql
RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld
# Exposer le port MariaDB
EXPOSE 3306
# Définir le volume pour la persistance des données
VOLUME ["/var/lib/mysql"]
# Script d'entrée pour initialiser et démarrer MariaDB
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["mysqld"]

