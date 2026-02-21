#!/bin/bash

sudo pacman -S --needed base-devel
cd /tmp
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si

