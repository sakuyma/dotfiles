#!/usr/bin/env bash
# vim: set ft=sh:

cliphist list | fuzzel --dmenu | cliphist --decode | wl-copy
