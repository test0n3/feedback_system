#!/usr/bin/env bash
set -euo pipefail

# Bridge RubyMine Gateway's XDG_CONFIG_HOME/XDG_DATA_HOME (hardcoded to
# /.jbdevcontainer/config and /.jbdevcontainer/data by the JetBrains devcontainer
# backend, see RUBY-34350) to the real mise install created by the "vscode" user.
# Gateway is expected to create these two directories itself before lifecycle
# commands run, so we neither mkdir nor chmod them here - only link into them.
ROOT_JB="/.jbdevcontainer"

# link_mise_dir SOURCE LINK_PATH
# Idempotent, non-destructive: skips if source is missing, skips if the link
# is already correct, warns (never fails the whole script) if link_path exists
# as something other than the expected symlink, or if creating the link fails
# (e.g. because "vscode" lacks write access under $ROOT_JB).
link_mise_dir() {
  local source="$1" link_path="$2"

  [ -d "$source" ] || return 0

  if [ -L "$link_path" ] && [ "$(readlink "$link_path")" = "$source" ]; then
    return 0
  fi

  if [ -e "$link_path" ] && [ ! -L "$link_path" ]; then
    echo "WARNING: $link_path exists and is not a symlink; leaving it as-is" >&2
    return 0
  fi

  ln -sf "$source" "$link_path" \
    || echo "WARNING: could not link $link_path -> $source" >&2
}

if [ -d "$ROOT_JB/config" ]; then
  link_mise_dir "$HOME/.config/mise" "$ROOT_JB/config/mise"
else
  echo "NOTE: $ROOT_JB/config not present; skipping RubyMine mise config link" >&2
fi

if [ -d "$ROOT_JB/data" ]; then
  link_mise_dir "$HOME/.local/share/mise" "$ROOT_JB/data/mise"
else
  echo "NOTE: $ROOT_JB/data not present; skipping RubyMine mise data link" >&2
fi
