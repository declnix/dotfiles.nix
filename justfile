hostname := env_var_or_default('HOSTNAME', `hostname`)

# Color codes
BLUE := '\033[1;34m'
GREEN := '\033[1;32m'
RESET := '\033[0m'

# Show available commands
[private]
default:
    @just --list

# Apply system configuration with optional extra args
switch *ARGS: eval-macros
    @just log "Applying NixOS configuration for {{hostname}}"
    @echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    @sudo nixos-rebuild switch --flake ".#{{hostname}}" {{ARGS}}
    @echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    @echo 
    @just success "Configuration activated and running"

# Build configuration with optional extra args
build *ARGS: eval-macros
    @just log "Building system configuration for {{hostname}}"
    @echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    @sudo nixos-rebuild build --flake ".#{{hostname}}" {{ARGS}}
    @echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    @echo
    @just success "Build complete → ./result"


# Remove old generations (5+ days)
[private]
clean:
    @sudo nix-collect-garbage --delete-older-than 5d

# Format Nix files
[private]
fmt:
    @nixfmt **/*.nix

# Evaluate macros and stage changes
[private]
eval-macros:
    @./eval-macros.sh | xargs -r git add

# Log message helper
[private]
log text:
    @echo -e "{{BLUE}}▸{{RESET}} {{text}}"

# Success message helper
[private]
success text:
    @echo -e "{{GREEN}}✓{{RESET}} {{text}}"