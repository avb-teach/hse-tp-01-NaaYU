#!/usr/bin/env bash
set -euo pipefail

max_depth=""
if [[ "${1-:-}" == "--max_depth" ]]; then
  max_depth="$2"
  shift 2
fi

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 [--max_depth N] <input_dir> <output_dir>"
  exit 1
fi

input_dir="$1"
output_dir="$2"

if [[ ! -d "$input_dir" ]]; then
  echo "Error: input directory '$input_dir' not found."
  exit 1
fi

mkdir -p "$output_dir"

find_args=()
if [[ -n "$max_depth" ]]; then
  find_args=( -maxdepth "$max_depth" )
fi

find "$input_dir" "${find_args[@]}" -type f -print0 | while IFS= read -r -d '' file; do
  name=$(basename "$file")
  base="${name%.*}"
  ext="${name##*.}"
  dest="$output_dir/$name"
  i=1
  while [[ -e "$dest" ]]; do
    dest="$output_dir/${base}_$i.${ext}"
    ((i++))
  done
  cp "$file" "$dest"
done
