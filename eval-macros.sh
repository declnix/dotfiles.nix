#!/usr/bin/env nix-shell
#!nix-shell -i bash -p perl gnugrep coreutils

# Recursively find files with macro markers
grep -rlE '^ *# */[^ ]* *::' . --include '*.nix' | while read -r file; do
  dir=$(dirname "$file")
  base=$(basename "$file")

  (
    cd "$dir" || exit 1
    perl -i -pe '
      if (/^(\s*)# \/[^ ]* :: (.*)$/) {
        print $_;
        $indent = $1;
        $cmd = $2;
        chomp($cmd);
        @out = `$cmd`;
        print map { "$indent$_" } @out;
        $_ = "";
        $in = 1;
      }
      elsif ($in && /^(\s*)# \/[^ ]*$/) {
        $in = 0;
        print $_;
        $_ = "";
      }
      elsif ($in) {
        $_ = "";
      }
    ' "$base"
  )

  echo $file
done
