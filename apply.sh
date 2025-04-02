#!/usr/bin/env bash
# Needs to be run as root

set -euxo pipefail
cp -f ./etc-nixos/* /etc/nixos
cp -f ./home-kyle-config-nixpkgs/* /home/kyle/.config/nixpkgs
nixos-rebuild switch
