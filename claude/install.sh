#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

mkdir -p "$CLAUDE_DIR"

ln -sf "$DOTFILES_DIR/settings.json"         "$CLAUDE_DIR/settings.json"
ln -sf "$DOTFILES_DIR/statusline-command.sh" "$CLAUDE_DIR/statusline-command.sh"
ln -sf "$DOTFILES_DIR/get-usage-reset.py"    "$CLAUDE_DIR/get-usage-reset.py"

echo "Done: claude config installed to $CLAUDE_DIR"
