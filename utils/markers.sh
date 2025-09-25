#!/usr/bin/env bash
set -euo pipefail

# Updates dynamic content between marker comments in files
# Markers format: # /marker_name :: command
#                 ... generated content ...
#                 # /marker_name

is_marker_start() {
    local line="$1"
    [[ "$line" =~ ^[[:space:]]*#[[:space:]]*/([^[:space:]]*)[[:space:]]*::[[:space:]]*(.*)$ ]]
}

is_marker_end() {
    local line="$1"
    [[ "$line" =~ ^[[:space:]]*#[[:space:]]*/([^[:space:]]*)$ ]]
}

get_marker_name() {
    local line="$1"
    [[ "$line" =~ ^[[:space:]]*#[[:space:]]*/([^[:space:]]*) ]]
    echo "${BASH_REMATCH[1]}"
}

get_marker_command() {
    local line="$1"
    [[ "$line" =~ ^[[:space:]]*#[[:space:]]*/[^[:space:]]*[[:space:]]*::[[:space:]]*(.*)$ ]]
    echo "${BASH_REMATCH[1]}"
}

get_line_indent() {
    local line="$1"
    echo "${line%%#*}"
}

execute_command_with_indent() {
    local command="$1"
    local indent="$2"
    local file_dir="$3"
    local tmp_file="$4"
    
    pushd "$file_dir" > /dev/null
    while IFS= read -r output_line; do
        echo "${indent}${output_line}" >> "$tmp_file"
    done < <(eval "$command")
    popd > /dev/null
}

update_markers() {
    local file="$1"
    local tmp_file
    tmp_file="$(mktemp)"
    
    local file_dir
    file_dir="$(dirname "$file")"
    
    local in_marker=false
    
    while IFS= read -r line || [[ -n "$line" ]]; do
        if is_marker_start "$line"; then
            local command
            command="$(get_marker_command "$line")"
            local indent
            indent="$(get_line_indent "$line")"
            
            echo "$line" >> "$tmp_file"
            execute_command_with_indent "$command" "$indent" "$file_dir" "$tmp_file"
            in_marker=true
            
        elif is_marker_end "$line" && [[ "$in_marker" == true ]]; then
            echo "$line" >> "$tmp_file"
            in_marker=false
            echo "$file"
            
        elif [[ "$in_marker" == false ]]; then
            echo "$line" >> "$tmp_file"
        fi
        
    done < "$file"
    
    mv "$tmp_file" "$file"
}

get_files_to_process() {
    if [[ $# -eq 0 ]]; then
        find . -name '*.nix'
    else
        printf '%s\n' "$@"
    fi
}

# Main script execution
files_to_process="$(get_files_to_process "$@")"

if [[ -z "$files_to_process" ]]; then
    echo "No *.nix files found in current directory tree" >&2
    exit 1
fi

while IFS= read -r file; do
    if [[ -f "$file" ]]; then
        update_markers "$file"
    else
        echo "Warning: File not found: $file" >&2
    fi
done <<< "$files_to_process"