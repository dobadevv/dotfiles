#!/bin/bash
# Claude Code shell initialization
# Sources zsh configuration to make functions/aliases available

# Respect ZDOTDIR if set, otherwise fall back to ~/.config/zsh or ~
ZDOTDIR="${ZDOTDIR:-${HOME}/.config/zsh}"

# Source zsh config (suppress errors for bash-incompatible syntax)
if [ -f "$ZDOTDIR/.zshrc" ]; then
  source "$ZDOTDIR/.zshrc" 2>/dev/null || true
elif [ -f "$HOME/.zshrc" ]; then
  source "$HOME/.zshrc" 2>/dev/null || true
fi
