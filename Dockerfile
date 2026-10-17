FROM ubuntu:26.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
	&& apt-get upgrade -y \
	&& apt-get install -y --no-install-recommends ca-certificates curl sudo tini \
	build-essential unzip zip jq ripgrep fd-find less procps bash-completion \
	man-db git openssh-client tmux xz-utils mariadb-client patch \
	locales python3-full python3-pip python3-venv \
	&& update-locale LANG=C.UTF-8 \
	&& rm -rf /var/lib/apt/lists/*

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN curl -fsSL https://deb.nodesource.com/setup_24.x | bash - \
	&& apt-get install -y --no-install-recommends nodejs \
	&& rm -rf /var/lib/apt/lists/*

# user-writable npm prefix; global npm tools install at container startup
ENV NPM_CONFIG_PREFIX=/home/ubuntu/.npm-global
ENV PATH=/home/ubuntu/.npm-global/bin:$PATH

# ubuntu:26.04 ships an ubuntu user with UID 1000
RUN id -u ubuntu >/dev/null 2>&1 || useradd -m -u 1000 -s /bin/bash ubuntu; \
	usermod -aG sudo ubuntu \
	&& echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/ubuntu \
	&& chmod 0440 /etc/sudoers.d/ubuntu \
	&& passwd -d ubuntu

RUN mkdir -p /workspace /home/ubuntu/.config/opencode \
	&& chown ubuntu:ubuntu /workspace \
	&& chown -R ubuntu:ubuntu /home/ubuntu

COPY --chmod=0755 entrypoint.sh /usr/local/bin/entrypoint.sh

EXPOSE 3000 4096

VOLUME /workspace
VOLUME /home/ubuntu/.config/opencode

USER ubuntu
WORKDIR /workspace

# openchamber binds 127.0.0.1 by default; published ports need the interface.
# No UI auth in this dev image, so explicitly allow LAN exposure.
ENV OPENCHAMBER_ALLOW_UNAUTHENTICATED_LAN=true
ENTRYPOINT ["/usr/bin/tini", "--", "entrypoint.sh"]
CMD ["openchamber", "--lan", "--foreground"]
