#!/usr/bin/env bash
pkill swaybg
swaybg -i "$1" -m fill &
echo "$1" > ~/.config/hypr/swaybg.conf
