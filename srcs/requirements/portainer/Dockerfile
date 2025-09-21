FROM debian:12

ENV PORTAINER_VERSION="2.19.4"

RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && wget https://github.com/portainer/portainer/releases/download/${PORTAINER_VERSION}/portainer-${PORTAINER_VERSION}-linux-amd64.tar.gz \
    && tar xzf portainer-${PORTAINER_VERSION}-linux-amd64.tar.gz -C /opt \
    && rm portainer-${PORTAINER_VERSION}-linux-amd64.tar.gz

EXPOSE 9000

ENTRYPOINT ["/opt/portainer/portainer"]
