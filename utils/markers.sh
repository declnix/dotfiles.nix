#!/usr/bin/env bash
set -euo pipefail

update_markers() {
  local file="$1"
  local tmp
  tmp="$(mktemp)"

  local dir
  dir="$(dirname "$file")"

  local in_marker=0

  # process the file line by line
  while IFS= read -r line || [[ -n "$line" ]]; do
    if [[ "$line" =~ ^[[:space:]]*#\ /([^[:space:]]*)\ ::\ (.*)$ ]]; then
      marker="${BASH_REMATCH[1]}"
      cmd="${BASH_REMATCH[2]}"

      echo "$line" >>"$tmp"

      # run command in file's dir
      pushd "$dir" >/dev/null
      while IFS= read -r output; do
        # preserve indentation of marker line
        indent="${line%%#*}"
        echo "${indent}$output" >>"$tmp"
      done < <(eval "$cmd")
      popd >/dev/null

      in_marker=1
    elif [[ "$line" =~ ^[[:space:]]*#\ /([^[:space:]]*)$ ]] && [[ $in_marker -eq 1 ]]; then
      marker_close="${BASH_REMATCH[1]}"
      echo "$line" >>"$tmp"
      in_marker=0
      echo "$file"
    elif [[ $in_marker -eq 0 ]]; then
      echo "$line" >>"$tmp"
    fi

  done <"$file"

  mv "$tmp" "$file"

}

# if no args → process all *.nix
if [[ $# -eq 0 ]]; then
  files=$(find . -name '*.nix')
else
  files="$@"
fi

for f in $files; do
  update_markers "$f"
done
