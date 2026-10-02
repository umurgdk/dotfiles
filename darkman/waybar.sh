#!/bin/sh
case "$1" in
dark) ln -sf theme-dark.css "$HOME/.config/waybar/theme.css" ;;
light) ln -sf theme-light.css "$HOME/.config/waybar/theme.css" ;;
esac
pkill -SIGUSR2 waybar
