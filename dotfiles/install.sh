#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")"

function install:dotfiles() {
  for file in .; do
    run=(
      stow --target ~          # Target directory
           --ignore .DS_Store  # Ignore files ending in this Perl regex
           --ignore install.sh # Ignore files ending in this Perl regex
           --restow            # prunes dead links
           --verbose 1 $file   # Options 0-5
           # --simulate        # use for testing
    )
    "${run[@]}"
  done
}

install:dotfiles
