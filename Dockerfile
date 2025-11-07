# Dockerfile for Formative 2: containerize the application
# Base image: specific and slim to keep image small and reproducible
FROM python:3.11-slim

# Metadata
LABEL maintainer="educonnect-team@example.com"

# Avoid interactive prompts during package installs
ENV DEBIAN_FRONTEND=noninteractive

# Create a non-root user for security and create app dir
RUN useradd --create-home --shell /bin/bash appuser \
    && mkdir -p /app

# Set working directory
WORKDIR /app

# Install system dependencies required to build Python packages (kept minimal)
RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential gcc \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements files and install Python deps early to leverage build cache
COPY requirements.txt requirements-dev.txt* /app/
RUN python -m pip install --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt \
    || (echo "Failed to install runtime requirements" && exit 1)

# Copy application source
COPY . /app

# Make sure app files are owned by non-root user
RUN chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

# Expose the port the app listens on (changed to 80 for assignment requirement)
EXPOSE 80

# Default command to run the Flask app. Uses app.py in repo root.
CMD ["python", "app.py"]
