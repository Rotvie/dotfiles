#! /bin/bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Paths relative to both $DOTFILES_DIR and $HOME. Nested paths are fine.
DOTFILES=(
    .gitconfig
    .zshrc
    .config/yt-dlp/config
    .config/mpv/mpv.conf
    .config/mpv/script-opts/subs2srs.conf
)

for dotfile in "${DOTFILES[@]}"; do
    src="$DOTFILES_DIR/$dotfile"
    dst="$HOME/$dotfile"
    mkdir -p "$(dirname "$dst")"
    cp "$src" "$dst"
done
