# ────────────────[ Environment Variables ]────────────────
export PATH="$HOME/.local/bin:$PATH"
export npm_config_cache="$HOME/.local/share/npm"
export BUN_INSTALL="$HOME/.local/share/bun"
export CARGO_INSTALL_ROOT="$HOME/.local"
export CARGO_HOME="$HOME/.local/share/cargo"
export RUSTUP_HOME="$HOME/.local/share/rustup"
export WINEPREFIX="$HOME/.local/share/wine"
export DIFFPROG="nvim"
export EDITOR="nvim"

# ────────────────[ Plugins ]────────────────
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ────────────────[ Zsh Options ]────────────────
autoload -Uz compinit && compinit
setopt autocd
setopt prompt_subst
setopt correct
setopt hist_ignore_dups
setopt share_history
setopt menucomplete

# ────────────────[ History ]────────────────
HISTFILE="$HOME/.local/state/zsh_history"
HISTSIZE=100000
SAVEHIST=100000
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt inc_append_history
setopt share_history

# ────────────────[ Prompt ]────────────────
eval "$(starship init zsh)"

# ────────────────[ Aliases ]────────────────
alias ff='clear && fastfetch'
alias ls='ls --color=auto --group-directories-first --human-readable -F'
alias grep='grep --color=auto'
