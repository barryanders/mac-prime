#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
agent_label="com.barry.mac-prime.update"
agent_source="$repo_dir/resources/launchagents/${agent_label}.plist"
agent_target="$HOME/Library/LaunchAgents/${agent_label}.plist"
sudoers_target="/private/etc/sudoers.d/mac-prime-nightly-update"

if [[ "$(id -un)" != "barry" ]]; then
  echo "Run this as barry, not as $(id -un)." >&2
  exit 1
fi

chmod +x "$repo_dir/scripts/nightly-update.sh"
mkdir -p "$HOME/Library/LaunchAgents" "$HOME/Library/Logs/mac-prime"
install -m 0644 "$agent_source" "$agent_target"

tmp_sudoers="$(mktemp)"
cat > "$tmp_sudoers" <<'SUDOERS'
Cmnd_Alias MAC_PRIME_NIGHTLY_UPDATE = \
  /usr/bin/install -m 0644 /Users/Barry//hosts /etc/hosts, \
  /usr/bin/install -m 0644 /Users/Barry//hosts.example /etc/hosts, \
  /usr/sbin/softwareupdate -i -a, \
  /usr/sbin/scutil --set ComputerName Holmes, \
  /usr/sbin/scutil --set HostName holmes, \
  /usr/sbin/scutil --set LocalHostName holmes, \
  /usr/bin/defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string holmes, \
  /usr/bin/chflags nohidden /Volumes, \
  /usr/bin/defaults write /Library/Preferences/SystemConfiguration/com.apple.DiskArbitration.diskarbitrationd.plist DADisableEjectNotification -bool YES, \
  /usr/bin/pkill diskarbitrationd, \
  /bin/rm -rf /Applications/Google\ Docs.app, \
  /bin/rm -rf /Applications/Google\ Sheets.app, \
  /bin/rm -rf /Applications/Google\ Slides.app, \
  /bin/rm -rfv /private/var/log/asl/*.asl, \
  /usr/bin/pkill coreaudiod

barry ALL=(root) NOPASSWD: MAC_PRIME_NIGHTLY_UPDATE
SUDOERS

if ! visudo -cf "$tmp_sudoers"; then
  rm -f "$tmp_sudoers"
  echo "Generated sudoers file did not validate; refusing to install it." >&2
  exit 1
fi

sudo install -o root -g wheel -m 0440 "$tmp_sudoers" "$sudoers_target"
rm -f "$tmp_sudoers"

launchctl bootout "gui/$(id -u)/$agent_label" 2>/dev/null || true
launchctl bootstrap "gui/$(id -u)" "$agent_target"
launchctl enable "gui/$(id -u)/$agent_label"

echo "Installed $agent_label. It will run nightly at 3:00 AM."
