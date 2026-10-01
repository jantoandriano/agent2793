# Shared helpers for engineering-agent scripts. Sourced, not executed.
# shellcheck shell=bash

# Engineering Agent root: the directory containing AGENTS.md.
EA_HOME="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && { pwd -W 2>/dev/null || pwd -P; })"

# Bash 5.2+ treats "&" in ${var//pattern/replacement} as the match; disable for literal templating.
shopt -u patsub_replacement 2>/dev/null || true

ea_die() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

ea_warn() {
  printf 'warning: %s\n' "$*" >&2
}

ea_require_git_repo() {
  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || ea_die "not inside a git repository"
}

ea_validate_ticket_id() {
  [[ "$1" =~ ^[A-Za-z][A-Za-z0-9_]*-[0-9]+$ ]] || ea_die "invalid ticket id '$1' (expected e.g. HYP-123)"
}

# Extract a ticket ID (e.g. HYP-123) from a branch name like feature/HYP-123.
ea_ticket_id_from_branch() {
  [[ "$1" =~ ([A-Za-z][A-Za-z0-9_]*-[0-9]+) ]] || return 1
  printf '%s\n' "${BASH_REMATCH[1]}"
}

# Absolute, symlink-resolved path of an existing directory (comparable across git and shell output).
# On Git Bash for Windows, prints the native form (D:/path) so editors and agents can open it.
ea_abspath() {
  (cd "$1" 2>/dev/null && { pwd -W 2>/dev/null || pwd -P; })
}

# The main worktree (original clone), even when called from a linked worktree.
ea_main_worktree() {
  local path
  path=$(git worktree list --porcelain | awk 'NR == 1 && /^worktree / { print substr($0, 10); exit }')
  [[ -n "$path" ]] || ea_die "cannot determine main worktree"
  ea_abspath "$path" || ea_die "main worktree '$path' is not accessible"
}

# Path of the worktree that has refs/heads/<branch> checked out, if any.
ea_worktree_for_branch() {
  git worktree list --porcelain |
    awk -v ref="refs/heads/$1" '/^worktree / { w = substr($0, 10) } $0 == "branch " ref { print w; exit }'
}

# Branch prefix for a ticket type.
ea_branch_prefix() {
  case "$1" in
    feature) echo feature ;;
    bug) echo bugfix ;;
    refactor) echo refactor ;;
    investigation) echo investigation ;;
    chore) echo chore ;;
    *) ea_die "invalid type '$1' (feature | bug | refactor | investigation | chore)" ;;
  esac
}

# Default worktree location: ../worktrees/<ID> next to the main worktree (override with EA_WORKTREE_ROOT).
ea_default_worktree_path() {
  local main=$1 id=$2
  printf '%s/%s\n' "${EA_WORKTREE_ROOT:-$(dirname "$main")/worktrees}" "$id"
}

# Default base: the branch origin/HEAD points to (local copy if present), else main/master/develop, else current.
ea_default_base() {
  local remote_head name
  remote_head=$(git symbolic-ref -q --short refs/remotes/origin/HEAD 2>/dev/null || true)
  if [[ -n "$remote_head" ]]; then
    name=${remote_head#origin/}
    if git show-ref --verify --quiet "refs/heads/$name"; then echo "$name"; else echo "$remote_head"; fi
    return
  fi
  for name in main master develop; do
    if git show-ref --verify --quiet "refs/heads/$name"; then
      echo "$name"
      return
    fi
  done
  git branch --show-current
}

# Keep .work/ out of git status in the target repository without modifying its tracked .gitignore.
ea_exclude_work_dir() {
  local main=$1 common exclude
  common=$(git -C "$main" rev-parse --git-common-dir)
  [[ "$common" = /* || "$common" =~ ^[A-Za-z]: ]] || common="$main/$common"
  exclude="$common/info/exclude"
  mkdir -p "$(dirname "$exclude")"
  grep -qxF '/.work/' "$exclude" 2>/dev/null || printf '/.work/\n' >>"$exclude"
}

# Read a scalar field from the YAML header of ticket.md (first "  key: value" match), unquoted.
ea_ticket_field() {
  local file=$1 key=$2
  awk -v key="$key" '
    $0 ~ "^[[:space:]]*" key ":" {
      sub("^[[:space:]]*" key ":[[:space:]]*", "")
      sub("[[:space:]]+#.*$", "")
      gsub(/^"|"$/, "")
      print
      exit
    }' "$file"
}

# Replace {{KEY}} placeholders in a template. Usage: ea_render <template> KEY=value ...
ea_render() {
  local content pair key value
  content=$(<"$1")
  shift
  for pair in "$@"; do
    key=${pair%%=*}
    value=${pair#*=}
    content=${content//"{{$key}}"/"$value"}
  done
  printf '%s\n' "$content"
}
