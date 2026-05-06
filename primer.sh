#!/usr/bin/env bash

source ~//dotfiles/.commands/text

function primer:section() {
  echo $(text invert)
  echo '                                                                                '
  printf ' :<%-76s>\n' "$1"
  echo '                                                                                '
  echo $(text)
}

primer:section "mac primer"
echo 'Requesting root access…'
sudo -v; while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

primer:section "install apps"
chmod +x ~//apps/install.sh
~//apps/install.sh

primer:section "install dotfiles"
chmod +x ~//dotfiles/install.sh
~//dotfiles/install.sh

primer:section "install dock"
~//dock

primer:section "install preferences"
~//preferences
