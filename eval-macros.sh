#!/usr/bin/env nix-shell
#!nix-shell -i bash -p perl gnugrep coreutils

# Find files with @macro markers
grep -rlE '@macro ::' . | while read -r file; do
  dir=$(dirname "$file")
  base=$(basename "$file")
  (
    cd "$dir" || exit 1
    perl -i -pe '
      # Match: # @macro :: command
      if (/^( *)# @macro :: (.+)$/) {
        print;
        $indent = $1;
        $cmd = $2;
        @out = `$cmd 2>&1`;
        print map { "$indent$_" } @out;
        $_ = "";
        $in_block = 1;
      }
      # Match: # @end
      elsif ($in_block && /^( *)# @end/) {
        $in_block = 0;
        print;
        $_ = "";
      }
      # Inside block: skip line
      elsif ($in_block) {
        $_ = "";
      }
    ' "$base"
  )
  echo "$file"
done