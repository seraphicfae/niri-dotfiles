# ────────────────[ Fish Options ]────────────────
set -U fish_greeting

# ────────────────[ ENVs ]────────────────
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_STATE_HOME "$HOME/.local/state"
set -gx XDG_CACHE_HOME "$HOME/.cache"
fish_add_path --append --path "$HOME/.local/bin"
fish_add_path --append --path "$XDG_DATA_HOME/cargo/bin"
set -gx WGETRC "$XDG_CONFIG_HOME/wget/wgetrc"
set -gx CARGO_HOME "$XDG_DATA_HOME/cargo"
set -gx RUSTUP_HOME "$XDG_DATA_HOME/rustup"
set -gx GNUPGHOME "$XDG_DATA_HOME/gnupg"
set -gx GOPATH "$XDG_DATA_HOME/go"
set -gx WINEPREFIX "$XDG_DATA_HOME/wineprefixes/default"
set -gx NPM_CONFIG_CACHE "$XDG_CACHE_HOME/npm"

set -gx TERMINAL alacritty
set -gx EDITOR helix

set -gx QT_QPA_PLATFORMTHEME qt6ct
set -gx XCURSOR_THEME breeze_cursors
set -gx XCURSOR_SIZE 24

# ────────────────[ Prompt ]────────────────
starship init fish | source

# ────────────────[ Aliases ]────────────────
alias ff='clear && fastfetch'
alias ls='ls --color=auto --group-directories-first --human-readable -F'
alias grep='grep --color=auto'
alias update='checkupdates && flatpak update && appman -u'
alias kill-orphans='sudo pacman -Rns $(pacman -Qtdq)'
