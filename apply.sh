#!/usr/bin/env bash
# Needs to be run as root

set -euxo pipefail
cp -f "/home/kyle/nix/etc-nixos/"* /etc/nixos
#cp -f "/home/kyle/nix/home-kyle-config-nixpkgs/"* /home/kyle/.config/nixpkgs
nixos-rebuild switch
