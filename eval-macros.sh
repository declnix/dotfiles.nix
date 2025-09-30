#!/usr/bin/env nix-shell
#!nix-shell -i bash -p perl gnugrep coreutils

# Find files with @macro markers
grep -rlE '@macro ::' . | grep -v eval-macros.sh | while read -r file; do
  dir=$(dirname "$file")
  base=$(basename "$file")
  
  (
    cd "$dir" || exit 1
    
    perl -i -pe '
      BEGIN { 
        $in_block = 0; 
      }
      
      # Found @macro line - execute command and insert output
      if (/^(\s*)# \@macro :: (.+)$/) {
        my $indent = $1;
        my $cmd = $2;
        chomp($cmd);
        
        # Execute command and capture output
        my @out = `$cmd 2>&1`;
        
        # Keep the @macro line
        $_ = $_;
        
        # Append each output line with proper indentation
        foreach my $line (@out) {
          chomp($line);
          $_ .= "${indent}$line\n";
        }
        
        $in_block = 1;
        next;
      }
      
      # Found @end line - exit block mode
      if ($in_block && /^\s*# \@end/) {
        $in_block = 0;
        next;
      }
      
      # Inside block - remove old content
      if ($in_block) {
        $_ = "";
        next;
      }
    ' "$base"
  )
  
  echo "$file"
done