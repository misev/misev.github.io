#!/bin/bash

f="$1"

[ -n "$f" ] || { echo "missing songs list filepath."; exit 1; }
[ -f "$f" ] || { echo "file not found: $f"; exit 1; }
if ! type yt-dlp > /dev/null 2>&1; then
  echo "yt-dlp not found, install it first with 'pip install yt-dlp'"
  exit 1
fi

# see https://stackoverflow.com/a/77233737
ytopts='--default-search ytsearch --dump-json --no-playlist --no-check-certificate --geo-bypass --flat-playlist --skip-download --ignore-errors'
while IFS= read -r song; do
  yturl="$(yt-dlp "ytsearch1:$song" $ytopts | jq '.url')"
  echo "- [$song]($yturl)"
done < "$f"
