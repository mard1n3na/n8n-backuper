# n8n-Backuper

A simple automated backup system for [n8n](https://n8n.io).

## Features
- Automatic backup of `/home/node/.n8n` (workflows, credentials, etc.)
- Sends zipped backups to your Telegram every X hours
- One-line install

## Installation

```bash
curl -sSL https://raw.githubusercontent.com/mard1n3na/n8n-backuper/main/install.sh | sudo bash
