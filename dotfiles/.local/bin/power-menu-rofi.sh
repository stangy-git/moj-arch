#!/bin/bash

action=$(printf "Odhlásiť sa\nReštart\nVypnúť\nRežim spánku" | rofi -dmenu -p -theme ~/.config/rofi/themes/custom_hyprland.rasi "Power Menu")

case $action in
  "Odhlásiť sa") hyprctl dispatch exit ;;
  "Reštart") systemctl reboot ;;
  "Vypnúť") systemctl poweroff ;;
  "Režim spánku") systemctl suspend ;;
esac
