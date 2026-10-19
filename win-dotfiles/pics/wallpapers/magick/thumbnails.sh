#!/usr/bin/env bash
# =============================================================================== #
# Thumbnail:                                                                      #
# =============================================================================== #
WALLPAPER_DIR="$HOME/.local/share/wall.dots/wallpapers"
THUMB_DIR="$WALLPAPER_DIR/.thumbnails"

for img in "$WALLPAPER_DIR"/*.{jpg,png}; do
  [[ -f "$img" ]] || continue
  thumb="$THUMB_DIR/$(basename "$img")"
  if [[ ! -f "$thumb" ]]; then
    magick "$img" -resize 320x180^ -gravity center -extent 320x180 "$thumb"
  fi
done
