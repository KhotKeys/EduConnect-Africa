FROM node:18-slim

WORKDIR /usr/src/app

RUN apt-get update \
    && apt-get install -y --no-install-recommends libcap2-bin ca-certificates \
    && npm install -g serve@14.2.5 --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
    # Allow non-root process to bind to low port (80) by granting node the CAP_NET_BIND_SERVICE
    && setcap 'cap_net_bind_service=+ep' "$(command -v node)" || true

RUN useradd --uid 1001 --home /home/appuser --create-home --shell /bin/bash appuser

COPY package.json package-lock.json* ./

COPY frontend ./frontend

RUN chown -R appuser:appuser /usr/src/app

USER appuser

EXPOSE 80

# Run the static server on port 80 (allowed by capability set above) as non-root
CMD ["serve", "-s", "-l", "tcp://0.0.0.0:80", "frontend"]
FROM node:18-slim

WORKDIR /usr/src/app

RUN apt-get update \
    && apt-get install -y --no-install-recommends libcap2-bin ca-certificates \
    && npm install -g serve@14.2.5 --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
    # Allow non-root process to bind to low port (80) by granting node the CAP_NET_BIND_SERVICE
    && setcap 'cap_net_bind_service=+ep' "$(command -v node)" || true

RUN useradd --uid 1001 --home /home/appuser --create-home --shell /bin/bash appuser

COPY package.json package-lock.json* ./

COPY frontend ./frontend

RUN chown -R appuser:appuser /usr/src/app

USER appuser

EXPOSE 80

# Run the static server on port 80 (allowed by capability set above) as non-root
CMD ["serve", "-s", "-l", "tcp://0.0.0.0:80", "frontend"]
