# Fzf
if [[ $- == *i* ]]; then
  source "$HOME/config/fzf/shell/completion.zsh"
  source "$HOME/config/fzf/shell/key-bindings.zsh"
  if executable bfs; then
    FZF_ALT_C_COMMAND="command bfs -nohidden -L -type d | cut -b3-"
  fi
fi

# Navi

# Sheldon
export SHELDON_CONFIG_DIR="${DOTFILES_DIR}/sheldon"

# Starship
export STARSHIP_CONFIG="${DOTFILES_DIR}/starship/starship.toml"

# Zoxide
export _ZO_FZF_OPTS='--height=40%'
zle -N zi && bindkey '\ej' zi  # ALT-J
zb() { cd "$(find_vcs_root)" }

# Starship
export STARSHIP_CONFIG="${DOTFILES_DIR}/starship/starship.toml"

eval "$(navi widget zsh)"
eval "$(sheldon source)"
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
