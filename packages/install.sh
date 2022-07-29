#!/usr/bin/env bash

cd ~//packages/
chmod +x *.sh

# Brew: The missing package manager for macOS
# https://github.com/Homebrew/brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew tap "homebrew/bundle"
brew bundle
brew cleanup
brew services cleanup
brew doctor
# Switch to using brew-installed bash as default shell
BREW_PREFIX=$(brew --prefix) # Homebrew's installed location
if ! fgrep -q "${BREW_PREFIX}/bin/bash" /etc/shells; then
  echo "${BREW_PREFIX}/bin/bash" | sudo tee -a /etc/shells;
  chsh -s "${BREW_PREFIX}/bin/bash";
fi;
