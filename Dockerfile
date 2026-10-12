FROM ubuntu:26.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends ca-certificates curl sudo \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://deb.nodesource.com/setup_24.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g @opencode/cli @openchamber/web \
    && npm cache clean --force

# ubuntu:26.04 ships an ubuntu user with UID 1000
RUN id -u ubuntu >/dev/null 2>&1 || useradd -m -u 1000 -s /bin/bash ubuntu \
    && usermod -aG sudo ubuntu \
    && echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/ubuntu \
    && chmod 0440 /etc/sudoers.d/ubuntu \
    && passwd -d ubuntu

RUN mkdir -p /workspace /home/ubuntu/.config/opencode \
    && chown ubuntu:ubuntu /workspace \
    && chown -R ubuntu:ubuntu /home/ubuntu/.config

EXPOSE 3000 4096

VOLUME /workspace
VOLUME /home/ubuntu/.config/opencode

USER ubuntu
WORKDIR /workspace

# openchamber binds 127.0.0.1 by default; published ports need the interface.
# No UI auth in this dev image, so explicitly allow LAN exposure.
ENV OPENCHAMBER_ALLOW_UNAUTHENTICATED_LAN=true
CMD ["openchamber", "--lan", "--foreground"]
