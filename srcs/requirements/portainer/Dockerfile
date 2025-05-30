FROM debian:11

# Installer les dépendances
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Télécharger directement le binaire (contournement du problème DNS)
ENV PORTAINER_VERSION="2.19.4"
RUN wget https://github.com/portainer/portainer/releases/download/${PORTAINER_VERSION}/portainer-${PORTAINER_VERSION}-linux-amd64.tar.gz && \
    tar xzf portainer-${PORTAINER_VERSION}-linux-amd64.tar.gz -C /opt && \
    rm portainer-${PORTAINER_VERSION}-linux-amd64.tar.gz

VOLUME /data

EXPOSE 9000
CMD ["/opt/portainer/portainer"]
