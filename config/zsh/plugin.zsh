# Fzf
if [[ $- == *i* ]]; then
  source "${DOTFILES_DIR}/fzf/shell/completion.zsh"
  source "${DOTFILES_DIR}/fzf/shell/key-bindings.zsh"
  # Use BFS by default to get better user experience in large codebase
  if executable bfs; then
    FZF_ALT_C_COMMAND="command bfs -nohidden -L -type d | cut -b3-"
    FZF_CTRL_T_COMMAND="command bfs -nohidden | cut -b3-"
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

declare -A eval_commands
eval_commands[navi]="widget zsh"
eval_commands[sheldon]="source"
eval_commands[starship]="init zsh"
eval_commands[zoxide]="init zsh"
for bin args in "${(@kv)eval_commands}"; do
  executable $bin && eval "$($bin ${=args})"
done
