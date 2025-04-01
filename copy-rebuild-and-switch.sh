#!/usr/bin/env bash
# Needs to be run as root

set -euxo pipefail
cp -f *nix /etc/nixos && nixos-rebuild switch
