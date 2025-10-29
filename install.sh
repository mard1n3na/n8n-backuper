#!/bin/bash
set -e

echo "──────────────────────────────"
echo "🧠 n8n Backuper Installer"
echo "──────────────────────────────"

read -p "Enter your Telegram Bot Token: " BOT_TOKEN
read -p "Enter your Telegram Chat ID: " CHAT_ID
read -p "Enter backup interval in hours (e.g. 1): " INTERVAL

INSTALL_DIR="/opt/n8n"
BACKUP_DIR="$INSTALL_DIR/backups"

mkdir -p "$BACKUP_DIR"

# ─── Create backup script ─────────────────────────
cat > $INSTALL_DIR/backup_n8n.sh <<EOF
#!/bin/bash
BACKUP_DIR="$BACKUP_DIR"
DATA_DIR="$INSTALL_DIR/n8n_data"
DATE=\$(date +'%Y-%m-%d_%H-%M-%S')
FILE="\$BACKUP_DIR/n8n_backup_\$DATE.zip"
mkdir -p "\$BACKUP_DIR"
zip -r "\$FILE" "\$DATA_DIR" >/dev/null 2>&1
echo "\$FILE"
EOF

# ─── Create telegram sender ───────────────────────
cat > $INSTALL_DIR/send_backup_to_telegram.sh <<EOF
#!/bin/bash
BOT_TOKEN="$BOT_TOKEN"
CHAT_ID="$CHAT_ID"
BACKUP_DIR="$BACKUP_DIR"
LATEST_BACKUP=\$(find "\$BACKUP_DIR" -type f -name "n8n_backup_*.zip" -printf "%T@ %p\n" 2>/dev/null | sort -n | tail -1 | cut -d' ' -f2-)
if [ -f "\$LATEST_BACKUP" ]; then
    /usr/bin/curl -s -F chat_id=\$CHAT_ID -F document=@\$\{LATEST_BACKUP\} https://api.telegram.org/bot\$\{BOT_TOKEN\}/sendDocument >/dev/null
    echo "✅ Backup sent to Telegram"
else
    echo "⚠️ No backup found!"
fi
EOF

chmod +x $INSTALL_DIR/backup_n8n.sh
chmod +x $INSTALL_DIR/send_backup_to_telegram.sh

# ─── Setup cron job ───────────────────────────────
(crontab -l 2>/dev/null; echo "0 */$INTERVAL * * * $INSTALL_DIR/backup_n8n.sh && $INSTALL_DIR/send_backup_to_telegram.sh") | crontab -

echo "──────────────────────────────"
echo "✅ Installation complete!"
echo "Backups will be sent to Telegram every $INTERVAL hour(s)."
echo "──────────────────────────────"
#!/bin/bash
set -e

echo "──────────────────────────────"
echo "🧠 n8n Backuper Installer"
echo "──────────────────────────────"

read -p "Enter your Telegram Bot Token: " BOT_TOKEN
read -p "Enter your Telegram Chat ID: " CHAT_ID
read -p "Enter backup interval in hours (e.g. 1): " INTERVAL

INSTALL_DIR="/opt/n8n"
BACKUP_DIR="$INSTALL_DIR/backups"

mkdir -p "$BACKUP_DIR"

# ─── Create backup script ─────────────────────────
cat > $INSTALL_DIR/backup_n8n.sh <<EOF
#!/bin/bash
BACKUP_DIR="$BACKUP_DIR"
DATA_DIR="$INSTALL_DIR/n8n_data"
DATE=\$(date +'%Y-%m-%d_%H-%M-%S')
FILE="\$BACKUP_DIR/n8n_backup_\$DATE.zip"
mkdir -p "\$BACKUP_DIR"
zip -r "\$FILE" "\$DATA_DIR" >/dev/null 2>&1
echo "\$FILE"
EOF

# ─── Create telegram sender ───────────────────────
cat > $INSTALL_DIR/send_backup_to_telegram.sh <<EOF
#!/bin/bash
BOT_TOKEN="$BOT_TOKEN"
CHAT_ID="$CHAT_ID"
BACKUP_DIR="$BACKUP_DIR"
LATEST_BACKUP=\$(find "\$BACKUP_DIR" -type f -name "n8n_backup_*.zip" -printf "%T@ %p\n" 2>/dev/null | sort -n | tail -1 | cut -d' ' -f2-)
if [ -f "\$LATEST_BACKUP" ]; then
    /usr/bin/curl -s -F chat_id=\$CHAT_ID -F document=@\$\{LATEST_BACKUP\} https://api.telegram.org/bot\$\{BOT_TOKEN\}/sendDocument >/dev/null
    echo "✅ Backup sent to Telegram"
else
    echo "⚠️ No backup found!"
fi
EOF

chmod +x $INSTALL_DIR/backup_n8n.sh
chmod +x $INSTALL_DIR/send_backup_to_telegram.sh

# ─── Setup cron job ───────────────────────────────
(crontab -l 2>/dev/null; echo "0 */$INTERVAL * * * $INSTALL_DIR/backup_n8n.sh && $INSTALL_DIR/send_backup_to_telegram.sh") | crontab -

echo "──────────────────────────────"
echo "✅ Installation complete!"
echo "Backups will be sent to Telegram every $INTERVAL hour(s)."
echo "──────────────────────────────"
