# ────────────────[ Fish Options ]────────────────
set -U fish_greeting

# ────────────────[ ENVs ]────────────────
fish_add_path --append --path "$HOME/.local/bin"
fish_add_path --append --path "$HOME/.local/share/cargo/bin"

# ────────────────[ Prompt ]────────────────
starship init fish | source

# ────────────────[ Aliases ]────────────────
alias ff='clear && fastfetch'
alias ls='ls --color=auto --group-directories-first --human-readable -F'
alias grep='grep --color=auto'
alias update='checkupdates && flatpak update && appman -u'
