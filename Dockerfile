FROM node:18-slim

WORKDIR /app

ENV NODE_ENV=production

## Create a non-root user for better security. We avoid forcing a specific UID
## because some base images may already have UID 1000 taken which causes
## the build to fail (seen on some official images). Let the system pick a
## free UID automatically.
RUN useradd --create-home --shell /bin/bash appuser

RUN npm install -g serve@14.2.5

COPY frontend ./frontend

RUN chown -R appuser:appuser /app

USER appuser

EXPOSE 80


CMD ["serve", "frontend", "-p", "80"]

