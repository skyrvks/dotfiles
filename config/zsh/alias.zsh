if executable exa; then
  alias ls='exa'
  alias ll='exa -l --icons'
  alias lr='exa -l --icons --sort new'
else
  alias ls='ls --color=auto'
  alias ll='ls -l'
  alias lr='ls -lrth'
fi

alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias sl='ls'

alias p='pueue'
alias pst='pueue status'
alias pad='pueue add'

if executable chezmoi; then
  alias cfg='chezmoi'
  alias cfg-cd='cd ~/.local/share/chezmoi'
fi
