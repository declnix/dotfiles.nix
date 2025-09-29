hostname := env_var_or_default('HOSTNAME', `hostname`)

# Color codes
BLUE := '\033[1;34m'
GREEN := '\033[1;32m'
RESET := '\033[0m'

# Show available commands
default:
    @just --list

# Apply system configuration with optional extra args
switch *ARGS: eval-macros
    @just log "Applying NixOS configuration for {{hostname}}"
    @sudo nixos-rebuild switch --flake ".#{{hostname}}" {{ARGS}}
    @just success "Configuration activated and running"

# Build configuration with optional extra args
build *ARGS: eval-macros
    @just log "Building system configuration for {{hostname}}"
    @sudo nixos-rebuild build --flake ".#{{hostname}}" {{ARGS}}
    @just success "Build complete → ./result"


# Remove old generations (5+ days)
clean:
    @sudo nix-collect-garbage --delete-older-than 5d

# Format Nix files
fmt:
    @nixfmt **/*.nix

# Evaluate macros and stage changes
eval-macros:
    #!/usr/bin/env bash
    changed_files=$(./eval-macros.sh)
    if [ -n "$changed_files" ]; then
        echo "$changed_files" | xargs git add
    fi

# Log message helper
log text:
    @echo -e "{{BLUE}}▸{{RESET}} {{text}}"

# Success message helper
success text:
    @echo -e "{{GREEN}}✓{{RESET}} {{text}}"