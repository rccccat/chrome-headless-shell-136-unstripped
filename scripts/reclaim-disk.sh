#!/usr/bin/env bash
set -euo pipefail

# GitHub-hosted runners are disposable. Remove preinstalled SDKs that Chromium
# does not use so the source tree and symbol build fit on the runner.
df -h /
sudo rm -rf /usr/share/dotnet
sudo rm -rf /usr/local/lib/android
sudo rm -rf /opt/ghc
sudo rm -rf /opt/hostedtoolcache/CodeQL
sudo rm -rf /usr/local/.ghcup
sudo rm -rf /usr/lib/jvm
sudo rm -rf /usr/share/swift
sudo docker image prune --all --force || true
sudo apt-get clean
df -h /
