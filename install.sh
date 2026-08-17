#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
CONFIG_DIR="$HOME/.config"

mkdir -p "$CONFIG_DIR"

for app in fastfetch kitty; do
  target="$CONFIG_DIR/$app"
  if [[ -e "$target" ]]; then
    backup="${target}.bak.$(date +%Y%m%d%H%M%S)"
    echo "Backing up existing $target -> $backup"
    mv "$target" "$backup"
  fi
  cp -r "$SCRIPT_DIR/.conf/$app" "$target"
  echo "Instalado $app en $target"
done
