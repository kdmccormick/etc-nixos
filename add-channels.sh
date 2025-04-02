#!/usr/bin/env bash
# Install all the channels we need, and update
# Should be run as root

set -euxo pipefail

nix-channel --add https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz home-manager
nix-channel --update

