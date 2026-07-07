#!/usr/bin/env bash
set -euo pipefail

if [[ -x /opt/homebrew/bin/bash && "${MAC_PRIME_NIGHTLY_BASH:-0}" != "1" ]]; then
  export MAC_PRIME_NIGHTLY_BASH=1
  exec /opt/homebrew/bin/bash "$0" "$@"
fi

export HOME="/Users/Barry"
export DOTFILES_UNATTENDED=1
export DOTFILES_SOUND=0

mkdir -p "$HOME/Library/Logs/mac-prime"

source "$HOME/.profile"

update
