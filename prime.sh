#!/usr/bin/env bash

source ~//dotfiles/.commands/text

section "mac prime"
echo 'Requesting root access…'
sudo -v; while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

section "install apps"
chmod +x ~//apps/install.sh
~//apps/install.sh

section "install dotfiles"
chmod +x ~//dotfiles/install.sh
~//dotfiles/install.sh

section "install dock"
~//dock

section "install preferences"
~//preferences

# Play completion sound
sfx play item_acquisition
