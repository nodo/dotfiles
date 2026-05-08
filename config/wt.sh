# shellcheck shell=bash
# Source this file from your interactive shell.
# `wt` is a function so `cd` changes the current shell.

if [[ -n "${BASH_VERSION:-}" ]]; then
  _WT_SCRIPT_PATH="${BASH_SOURCE[0]}"
elif [[ -n "${ZSH_VERSION:-}" ]]; then
  _WT_SCRIPT_PATH="${(%):-%x}"
fi

if [[ -n "${_WT_SCRIPT_PATH:-}" ]]; then
  _WT_SCRIPT_DIR=$(cd -- "$(dirname -- "$_WT_SCRIPT_PATH")" >/dev/null 2>&1 && pwd -P)
  _WT_SCRIPT_PATH="$_WT_SCRIPT_DIR/$(basename -- "$_WT_SCRIPT_PATH")"
fi

_wt_create_worktree() {
  local git_root repo_name worktrees_dir branch worktree path

  git_root=$(git rev-parse --show-toplevel) || return 1
  repo_name=$(basename -- "$git_root")
  worktrees_dir="$(dirname -- "$git_root")/${repo_name}_worktrees"

  printf '\nBranch name: ' >/dev/tty
  IFS= read -r branch </dev/tty || return 1
  [[ -z "$branch" ]] && return 0

  printf 'Worktree name [%s]: ' "$branch" >/dev/tty
  IFS= read -r worktree </dev/tty || return 1
  [[ -z "$worktree" ]] && worktree="$branch"

  path="$worktrees_dir/$worktree"

  mkdir -p -- "$worktrees_dir"

  if git show-ref --verify --quiet "refs/heads/$branch"; then
    git worktree add "$path" "$branch"
  else
    git worktree add -b "$branch" "$path"
  fi

  printf '\nCreated %s\nPress enter to continue...' "$path" >/dev/tty
  IFS= read -r _ </dev/tty
}

_wt_remove_worktrees() {
  [[ "${FZF_SELECT_COUNT:-0}" -eq 0 ]] && return 0

  local dir
  for dir in "$@"; do
    git worktree remove "$dir"
  done
}

wt() {
  local dir script_path
  script_path=$(printf '%q' "$_WT_SCRIPT_PATH")

  dir=$(
    git worktree list |
      fzf \
        --height=40% \
        --reverse \
        --multi \
        --bind 'space:toggle' \
        --bind "n:execute(bash $script_path __create)+reload(git worktree list)" \
        --bind "ctrl-d:execute-silent(bash $script_path __remove {+1})+reload(git worktree list)" \
        --header 'space: toggle selection · enter: cd · n: new worktree · ctrl-d: delete selected' |
      awk 'NR == 1 {print $1}'
  )
  [[ -n "$dir" ]] && cd "$dir"
}

if [[ -n "${BASH_VERSION:-}" && "${BASH_SOURCE[0]}" == "$0" ]]; then
  case "${1:-}" in
    __create)
      _wt_create_worktree
      ;;
    __remove)
      shift
      _wt_remove_worktrees "$@"
      ;;
  esac
fi
