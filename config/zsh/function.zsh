function executable() {
  command -v "$1" > /dev/null 2>&1
}

function find_vcs_root() {
  # DOTFILES_ROOT_MARKERS
  local markers=(.git .root)
  local dir="$(readlink -f "${1:-$PWD}")"
  local found=false
  while ! "$found"; do
    for marker in "${markers[@]}"; do
      if [[ -d "$dir/$marker" ]]; then
        echo "$dir"
        found=true
        break
      fi
    done
    local parent= parent="$(dirname "$dir")"
    if [[ "$dir" = "$parent" ]]; then
      break
    fi
    dir="$parent"
  done
}
