#!/usr/bin/env bash

source ~//dotfiles/.commands/text

function prime:section() {
  echo $(text invert)
  echo '                                                                                '
  printf ' :<%-76s>\n' "$1"
  echo '                                                                                '
  echo $(text)
}

prime:section "mac prime"
echo 'Requesting root access…'
sudo -v; while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

prime:section "install apps"
chmod +x ~//apps/install.sh
~//apps/install.sh

prime:section "install dotfiles"
chmod +x ~//dotfiles/install.sh
~//dotfiles/install.sh

prime:section "install dock"
~//dock

prime:section "install preferences"
~//preferences

# Play completion sound
afplay ~//resources/sounds/powerup.wav 2>/dev/null &
