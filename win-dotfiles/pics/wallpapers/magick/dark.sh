#!/usr/bin/env bash
# =============================================================================== #
# Darken:                                                                         #
# =============================================================================== #
if [ -z "$1" ]
then
  echo "Usage: darken-image  [contrast=40]"
  echo ""
  exit 1
fi

in_filename="$1"
amount=${2:-40}

# Set output filename to original filename with "-darker" appended
extension="${in_filename##*.}"
name="${in_filename%.*}"
out_filename="${name}-darker.${extension}"

# Use ImageMagick to darken the original image and create the new file
convert "$in_filename" -fill black -colorize "$amount"% "$out_filename"

echo "Darkened image created: $out_filename"
