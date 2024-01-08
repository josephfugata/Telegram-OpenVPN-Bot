#!/bin/bash

# This will install telegram bot for Ubuntu 20.04 OpenVPN Server

# Check if Git is installed, if not, install it silently
if ! command -v git &> /dev/null
then
    echo "Git is not installed. Installing Git..."
    apt install git -y
fi

# Check if Python3 is installed, if not, install it silently
if ! command -v python3 &> /dev/null
then
    echo "Python3 is not installed. Installing Python3..."
    apt install python3 -y
fi

# Check if Pip (Python package installer) is installed, if not, install it silently
if ! command -v pip3 &> /dev/null
then
    echo "Pip3 is not installed. Installing Pip3..."
    apt install python3-pip -y
fi

# Check if Telepot is installed, if not, install it silently
if ! python3 -c "import telepot" &> /dev/null
then
    echo "Telepot is not installed. Installing Telepot..."
    python3 -m pip install telepot
fi

# Ask for user input
read -p "Enter your Telegram Bot Token: " BOT_TOKEN
read -p "Enter your Server Name: " SERVER_NAME
read -p "Enter your Telegram Chat ID: " TELEGRAM_CHAT_ID

# Clone OpenVPN Manager repository
git clone https://github.com/royalmo/openvpn-manager.git /root/openvpn-manager

# Replace placeholders with user input
echo "[GENERAL]
BOT_TOKEN = $BOT_TOKEN
SERVER_NAME = $SERVER_NAME
[ADMINS]
Joseph = $TELEGRAM_CHAT_ID" > /root/openvpn-manager/settings.ini

# Create systemd service for the Telegram bot
echo '[Unit]
Description=Start My Telegram Bot
After=multi-user.target
[Service]
Type=simple
Restart=always
ExecStart=nohup python3 /root/openvpn-manager/main.py &
[Install]
WantedBy=multi-user.target' > /etc/systemd/system/telegrambot.service

# Reload systemd, enable, and start the service
systemctl daemon-reload && systemctl enable telegrambot.service && systemctl start telegrambot.service

# Instructions for setting up commands in @botFather
echo '
Go to your BotFather and set commands using /setcommands
start - Welcome message.
help - Display the list of commands.
create - Create an OpenVPN profile.
revoke - Revoke an OpenVPN profile.
active - List active OpenVPN profiles.
'
read -p "Enter To Continue... "


echo '
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
net.ipv4.tcp_fastopen=3' >> /etc/sysctl.conf

sysctl -p






