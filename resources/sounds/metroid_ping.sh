#!/bin/bash
# Metroid Prime Attention Ping
# Enabled/Disabled via DOTFILES_SOUND environment variable

[[ "$DOTFILES_SOUND" != "1" ]] && exit 0

SOUND_PATH="$HOME//resources/sounds/into_hud.wav"

if [ -f "$SOUND_PATH" ]; then
    afplay "$SOUND_PATH"
else
    # Fallback to terminal bell
    echo -e "\a"
fi
