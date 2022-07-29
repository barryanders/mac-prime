#!/usr/bin/env bash
echo
# Mac Prime
echo 'Mac Prime'
echo

# Packages
echo 'Packages'
echo '················································································'
echo
echo 'Installing Packages…'
chmod +x ~//Packages/install.sh
~//packages/install.sh
echo

# Dotfiles
echo 'Dotfiles'
echo '················································································'
echo
echo 'Installing Dotfiles…'
chmod +x ~//Dotfiles/install.sh
~//dotfiles/install.sh
echo

# Preferences
echo 'Preferences'
echo '················································································'
echo
echo 'Setting Preferences…'
~//preferences
~//dock
