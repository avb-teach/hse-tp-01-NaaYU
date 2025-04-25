#!/bin/bash

input_dir="$1"
output_dir="$2"

if [ ! -d "$input_dir" ] || [ ! -d "$output_dir" ]; then
  echo "Usage: $0 /path/to/input_dir /path/to/output_dir"
  exit 1
fi

counter=1
find "$input_dir" -type f | while read -r file; do
  filename=$(basename "$file")
  base="${filename%.*}"
  ext="${filename##*.}"

  newname="$filename"
  while [ -e "$output_dir/$newname" ]; do
    newname="${base}${counter}.$ext"
    ((counter++))
  done

  cp "$file" "$output_dir/$newname"
done