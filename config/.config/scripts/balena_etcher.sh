#!/usr/bin/env bash

sudo pacman -S --needed zip

wget https://github.com/balena-io/etcher/releases/download/v2.1.6/balenaEtcher-linux-x64-2.1.6.zip

unzip balenaEtcher-linux-x64-2.1.6.zip 

cd balenaEtcher-linux-x64

./balena-etcher
