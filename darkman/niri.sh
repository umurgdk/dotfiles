#!/bin/sh

echo $NIRI_SOCKET
ls $NIRI_SOCKET

case "$1" in
dark) niri msg action load-config-file --path "$HOME/.config/niri/config_dark.kdl" ;;
light) niri msg action load-config-file --path "$HOME/.config/niri/config_light.kdl" ;;
esac
