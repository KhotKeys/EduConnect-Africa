FROM node:20-slim

WORKDIR /usr/src/app

RUN npm install --no-audit --no-fund -g serve@14.2.5

# Install libcap so we can give the node binary permission to bind to low ports
# without running the process as root (better security than running as root).
RUN apt-get update \
    && apt-get install -y --no-install-recommends libcap2-bin ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd -r app && useradd -r -g app -d /home/app -s /sbin/nologin app \
    && mkdir -p /home/app

COPY . .

RUN chown -R app:app /usr/src/app

USER app

EXPOSE 80

RUN setcap 'cap_net_bind_service=+ep' /usr/local/bin/node || true

# Default command: serve the static frontend on port 80
CMD ["serve", "-s", "frontend", "-l", "80"]

