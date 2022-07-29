# Set prompt to `starship`
eval "$(starship init bash)"

# Add `zoxide` to shell
eval "$(zoxide init bash)"

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
  shopt -s "$option" 2> /dev/null;
done;

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# Add tab completion for many Bash commands
if which brew &> /dev/null && [ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]; then
  # Ensure existing Homebrew v1 completions continue to work
  export BASH_COMPLETION_COMPAT_DIR="$(brew --prefix)/etc/bash_completion.d";
  source "$(brew --prefix)/etc/profile.d/bash_completion.sh";
elif [ -f /etc/bash_completion ]; then
  source /etc/bash_completion;
fi;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults;

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Add timestamps to history
# Date/time formatting: http://www.acehints.com/2012/07/histtimeformat-how-to-see-linux.html
HISTTIMEFORMAT="|  %F  |  %r  |  "

# Tell SSH how to access gpg-agent by changing the value of SSH_AUTH_SOCK
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent

# Load the shell dotfiles, and then some:
# ~/.path can be used to extend `$PATH`.
# ~/.commands is where you can put custom aliases and functions.
# ~/.private can be used for other settings you don't want to commit.
for file in ~/.{path,exports,commands/*,private}; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file"
done;
unset file;
