# Hostname from env or fallback
hostname := env_var_or_default('HOSTNAME', `hostname`)

# Color codes
BLUE := '\033[1;34m'
GREEN := '\033[1;32m'
RESET := '\033[0m'

# Default: list commands
[private]
@default:
    just --list

# Apply system configuration
@switch *ARGS: eval-macros
    just log "Applying NixOS configuration [host={{hostname}}]"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    impure_flag=""; \
    if [ -r "./hosts/{{hostname}}" ] && grep -qr "@impure" "./hosts/{{hostname}}"; then \
        impure_flag="--impure"; \
    fi; \
    sudo -E nixos-rebuild switch --flake ".#{{hostname}}" $impure_flag {{ARGS}}
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo
    just log "Configuration activated and running {{GREEN}}✓{{RESET}}"


# Build configuration
@build *ARGS: eval-macros
    just log "Building system configuration [host={{hostname}}]"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    impure_flag=""; \
    if [ -r "./hosts/{{hostname}}" ] && grep -qr "@impure" "./hosts/{{hostname}}"; then \
        impure_flag="--impure"; \
    fi; \
    sudo -E nixos-rebuild build --flake ".#{{hostname}}" $impure_flag {{ARGS}}
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo
    just log "Build complete → ./result {{GREEN}}✓{{RESET}}"

# Clean old generations
[private]
@clean:
    sudo nix-collect-garbage --delete-older-than 5d

# Format Nix files
[private]
@fmt:
    nixfmt **/*.nix

# Evaluate macros
[private]
@eval-macros:
    ./eval-macros.sh | xargs -r git add

# Logging
[private]
@log text:
    echo -e "{{BLUE}}▸{{RESET}} {{text}}"

# Success
[private]
@success text:
    echo -e "{{GREEN}}✓{{RESET}} {{text}}"
