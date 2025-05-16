#!/bin/bash
ALERTMANAGER_VERSION="0.28.0"
wget https://github.com/prometheus/alertmanager/releases/download/v${ALERTMANAGER_VERSION}/alertmanager-${ALERTMANAGER_VERSION}.linux-amd64.tar.gz
tar xvzf alertmanager-${ALERTMANAGER_VERSION}.linux-amd64.tar.gz
cd alertmanager-${ALERTMANAGER_VERSION}.linux-amd64/
# if you just want to start prometheus as root
#./alertmanager --config.file=simple.yml

# create user
useradd --no-create-home --shell /bin/false alertmanager

# create directories
mkdir /etc/alertmanager
mkdir /etc/alertmanager/template
mkdir -p /var/lib/alertmanager/data

# touch config file
touch /etc/alertmanager/alertmanager.yml

# set ownership
chown -R alertmanager:alertmanager /etc/alertmanager
chown -R alertmanager:alertmanager /var/lib/alertmanager

# copy binaries
cp alertmanager /usr/local/bin/
cp amtool /usr/local/bin/

# set ownership
chown alertmanager:alertmanager /usr/local/bin/alertmanager
chown alertmanager:alertmanager /usr/local/bin/amtool

# setup systemd
echo '[Unit]
Description=Prometheus Alertmanager Service
Wants=network-online.target
After=network.target

[Service]
User=alertmanager
Group=alertmanager
Type=simple
ExecStart=/usr/local/bin/alertmanager \
    --config.file /etc/alertmanager/alertmanager.yml \
    --storage.path /var/lib/alertmanager/data
Restart=always

[Install]
WantedBy=multi-user.target' > /etc/systemd/system/alertmanager.service

systemctl daemon-reload
systemctl enable alertmanager
systemctl start alertmanager
