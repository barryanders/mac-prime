#!/usr/bin/env bash

set -euo pipefail

echo 'Installing dotfiles…'

cd "$(dirname "${BASH_SOURCE[0]}")"

DOTFILES_DIR="$PWD"
CONFIG_DIR="$DOTFILES_DIR/.config"
timestamp="$(date +%Y%m%d-%H%M%S)"

function prepare_target() {
  local target="$1"
  local source="$2"
  local target_parent

  target_parent="$(dirname "$target")"
  mkdir -p "$target_parent"

  if [[ -L "$target" && "$(readlink "$target")" == "$source" ]]; then
    return
  fi

  if [[ -L "$target" ]]; then
    rm "$target"
  fi

  if [[ -f "$target" ]]; then
    if cmp -s "$target" "$source"; then
      rm "$target"
    else
      mv "$target" "${target}.bak-$timestamp"
    fi
    return
  fi

  if [[ -d "$target" ]]; then
    mv "$target" "${target}.bak-$timestamp"
  fi
}

function link_entry() {
  local source="$1"
  local target="$2"

  prepare_target "$target" "$source"

  if [[ -L "$target" && "$(readlink "$target")" == "$source" ]]; then
    return
  fi

  ln -s "$source" "$target"
}

function install_root_dotfiles() {
  local name

  while IFS= read -r source; do
    name="$(basename "$source")"

    case "$name" in
      .|..|install.sh|.stow-local-ignore|.config|home|config)
        continue
        ;;
    esac

    link_entry "$DOTFILES_DIR/$source" "$HOME/$name"
  done < <(find . -mindepth 1 -maxdepth 1 | sort)
}

function install_config() {
  local name

  [[ -d "$CONFIG_DIR" ]] || return
  mkdir -p "$HOME/.config"

  while IFS= read -r source; do
    name="$(basename "$source")"
    link_entry "$DOTFILES_DIR/$source" "$HOME/.config/$name"
  done < <(find .config -mindepth 1 -maxdepth 1 | sort)
}

install_root_dotfiles
install_config
