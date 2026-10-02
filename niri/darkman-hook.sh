#!/bin/bash
set -euo pipefail

NIRI_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/niri"

case "$1" in
    dark)
        niri msg action load-config-file --path "$NIRI_DIR/config_dark.kdl"
        ;;
    light)
        niri msg action load-config-file --path "$NIRI_DIR/config_light.kdl"
        ;;
esac
