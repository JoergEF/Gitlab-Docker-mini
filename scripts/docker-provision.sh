#!/bin/sh

# APT im nicht-interaktiven Modus
export DEBIAN_FRONTEND=noninteractive

# Docker installieren
apt-get -y install apt-transport-https ca-certificates curl \
    gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
    | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get -y install docker-ce docker-ce-cli containerd.io \
  git docker-compose
systemctl enable --now docker
adduser vagrant docker

# Konfiguration der Namensauflösung
systemctl disable --now systemd-resolved
rm /etc/resolv.conf
echo "nameserver 192.168.1.11" > /etc/resolv.conf
echo "search kurs.iad" >> /etc/resolv.conf

# Gitlab-Zertifikat importieren
[ -d /etc/docker/certs.d/gitlab:5050 ] || mkdir -p /etc/docker/certs.d/gitlab:5050
openssl s_client -showcerts -connect gitlab:443 < /dev/null 2>/dev/null | openssl x509 -outform PEM > /etc/docker/certs.d/gitlab\:5050/gitlab.crt
