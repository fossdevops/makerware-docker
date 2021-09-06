# The details can be found in the following web page.
# https://support.makerbot.com/learn/makerbot-desktop-software/getting-started/how-to-install-makerbot-desktop-for-linux_11262
ARG IMAGE_VERSION=${IMAGE_VERSION:-main}
ARG REGISTRY_URI=${REGISTRY_URI:-ghcr.io/}
ARG IMAGE_NAME=${IMAGE_NAME:-fossdevops/makerware-conveyor-docker}
FROM ${REGISTRY_URI}${IMAGE_NAME}:${IMAGE_VERSION} as base

USER root

# Enable headless (cli) package installs
ARG DEBIAN_FRONTEND=noninteractive

# enable upgrade periodic (daily) trigger, do upgrades, install https support for apt, and install lsb_release
# FYI: apt will always complain about makerbot's repo as it uses sha1 for its gpg signature
ARG UPDATE_TIMESTAMP
RUN (date > /etc/fossdevops_apt_date) && \
    apt-get update -y && \
    apt-get -o Dpkg::Options::="--force-confold" upgrade -y && \
    apt-get -o Dpkg::Options::="--force-confold" install apt-transport-https lsb-release -y && \
    apt-get -y autoremove && apt-get -y clean && rm -rf /var/lib/apt/lists/*

# Install makerware, xdg-utils (to open files in qt), and glogg log viewer (to watch logs)
ARG UBUNTU_VERSION=${UBUNTU_VERSION:-xenial}
RUN apt-get update && \
    apt-get -o Dpkg::Options::="--force-confold" install makerware libqt5webkit5 libyajl2 xdg-utils glogg -y && \
    apt-get -y autoremove && apt-get -y clean && rm -rf /var/lib/apt/lists/*

# give the conveyor user a home directory
RUN usermod -d /home/conveyor conveyor && \
    mkdir -p /home/conveyor/.local/share/applications /home/conveyor/.config && \
    chown -R conveyor:conveyor /home/conveyor

# set glogg as the log viewer
USER conveyor
RUN xdg-mime default glogg.desktop text/x-log
USER root

# Start conveyor service
ENV LD_LIBRARY_PATH=
ENTRYPOINT [ "/usr/share/makerbot/makerware" ]
CMD []

# Versioning and docker metadata stuff
LABEL org.opencontainers.image.authors='FOSSDevOps <support@fossdevops.com>'
LABEL org.opencontainers.image.url='https://github.com/fossdevops/makerware-docker'
LABEL org.opencontainers.image.documentation='https://fossdevops.github.io/makerware-docker'
LABEL org.opencontainers.image.source='https://github.com/fossdevops/makerware-docker.git'
LABEL org.opencontainers.image.vendor='FOSSDevOps'
#LABEL org.opencontainers.image.licenses=''
LABEL org.opencontainers.image.title='ghcr.io/fossdevops/makerware-docker'
LABEL org.opencontainers.image.description="Docker image containing the Makerbot makerware (Makerbot Desktop) application"

# set version stuff
ARG VERSION=unset
ARG LONG_FORM_VERSION=unset
RUN (printf 'Makerbot Makerware Container' > /etc/fossdevops_product) && \
    (printf '%s' "${VERSION}" > /etc/fossdevops_version) && \
    (printf '%s' "${LONG_FORM_VERSION}" > /etc/fossdevops_version_long)

# Changing the user must be last
USER conveyor