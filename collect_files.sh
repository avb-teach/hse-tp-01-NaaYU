#!/bin/bash

INPUT_DIR="$1"
OUTPUT_DIR="$2"

if [[ "$#" -lt 2 ]]; then
  echo "Usage: $0 <input_dir> <output_dir> [--max_depth N]"
  exit 1
fi

MAX_DEPTH=""
if [[ "$3" == "--max_depth" && -n "$4" ]]; then
  MAX_DEPTH="$4"
fi

mkdir -p "$OUTPUT_DIR"

copy_files() {
  local dir="$1"
  local current_depth="$2"

  for item in "$dir"/*; do
    if [[ -f "$item" ]]; then
      filename=$(basename "$item")
      base="${filename%.*}"
      ext="${filename##*.}"
      dest="$OUTPUT_DIR/$filename"
      counter=1
      while [[ -e "$dest" ]]; do
        dest="$OUTPUT_DIR/${base}${counter:+_$counter}.${ext}"
        ((counter++))
      done
      cp "$item" "$dest"
    elif [[ -d "$item" ]]; then
      if [[ -z "$MAX_DEPTH" || "$current_depth" -lt "$MAX_DEPTH" ]]; then
        copy_files "$item" $((current_depth + 1))
      fi
    fi
  done
}

copy_files "$INPUT_DIR" 1