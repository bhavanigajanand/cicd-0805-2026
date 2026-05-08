#!/bin/bash
set -e

echo "========================================="
echo " Starting EC2 User Data Setup"
echo "========================================="

# ─────────────────────────────────────────
# System update
# ─────────────────────────────────────────
dnf update -y

# ─────────────────────────────────────────
# Install Docker
# ─────────────────────────────────────────
echo "Installing Docker..."
dnf install -y docker
systemctl enable docker
systemctl start docker

# Allow ec2-user to run Docker without sudo
usermod -aG docker ec2-user

# ─────────────────────────────────────────
# Install Docker Compose (v2 plugin)
# ─────────────────────────────────────────
echo "Installing Docker Compose..."
DOCKER_COMPOSE_VERSION="v2.27.0"
mkdir -p /usr/local/lib/docker/cli-plugins
curl -SL "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-linux-x86_64" \
  -o /usr/local/lib/docker/cli-plugins/docker-compose
chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

# Symlink so both `docker-compose` and `docker compose` work
ln -sf /usr/local/lib/docker/cli-plugins/docker-compose /usr/bin/docker-compose

# ─────────────────────────────────────────
# Install Git
# ─────────────────────────────────────────
echo "Installing Git..."
dnf install -y git

# ─────────────────────────────────────────
# Pull and start Jenkins via Docker Compose
# ─────────────────────────────────────────
echo "Pulling Jenkins Docker image..."
docker pull jenkins/jenkins:lts

echo "========================================="
echo " Setup complete!"
echo " Jenkins : http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):8080"
echo " App     : http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):5000"
echo " Run: docker-compose up -d to start everything"
echo "========================================="
