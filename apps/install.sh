#!/usr/bin/env bash
set -euo pipefail

HOMEBREW_INSTALL_URL="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"

echo 'Installing apps…'
cd "${HOME}//apps"

if compgen -G "*.sh" >/dev/null; then
  chmod +x -- *.sh
fi

if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL "$HOMEBREW_INSTALL_URL")"
fi

BREW_CMD="$(command -v brew || true)"
if [[ -z "$BREW_CMD" && -x /opt/homebrew/bin/brew ]]; then
  BREW_CMD="/opt/homebrew/bin/brew"
fi
if [[ -z "$BREW_CMD" && -x /usr/local/bin/brew ]]; then
  BREW_CMD="/usr/local/bin/brew"
fi
if [[ -z "$BREW_CMD" ]]; then
  echo "Homebrew not found after install attempt." >&2
  exit 1
fi

"$BREW_CMD" tap "homebrew/bundle"
"$BREW_CMD" bundle
"$BREW_CMD" cleanup
"$BREW_CMD" doctor

eval "$("$BREW_CMD" shellenv)"

BREW_PREFIX=$("$BREW_CMD" --prefix)
BREW_BASH="${BREW_PREFIX}/bin/bash"

if ! fgrep -q "$BREW_BASH" /etc/shells; then
  echo "$BREW_BASH" | sudo tee -a /etc/shells > /dev/null
fi

if [[ "${SHELL}" != "$BREW_BASH" ]]; then
  chsh -s "$BREW_BASH"
fi
