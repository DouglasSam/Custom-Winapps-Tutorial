#!/bin/bash

# Uninstall winapps

winapps-setup -- user -- uninstall

# stop windows vm

winvm-kill

# delete docker windows container

docker container rm WinApps

# delete docker windows volume

docker volume rm winapps_data

# delete docker windows image

docker image rm ghcr.io/dockur/windows:latest

# delete docker windows network

docker network rm winapps_default

# remove all volumes

rm -r "$HOME/.config/winapps"
rm -rf "$HOME/.local/bin/winapps-src"

# Remove winvm aliases and cleanup shell config
sed -i '/WinApps Docker Compose aliases/,/EOF/d' ~/.bashrc 2>/dev/null

# Remove freerdp certificate
rm -r "$HOME/.config/freerdp"