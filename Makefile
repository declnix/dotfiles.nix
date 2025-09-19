# Define the files to be formatted
FILES ?= **/*.nix

# Macro to print a banner for command output
define print_banner
    @echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    @echo "> $(1)"
    @echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    @echo ""
endef

################################################################################
# 🚀 System Deployment Commands
################################################################################

# Define the flake target. By default, it uses the current directory's flake
# and the hostname as the attribute (e.g., .#my-hostname).
# You can override this on the command line, for example:
# make apply FLAKE_TARGET="github:NixOS/nixpkgs/nixos-unstable"
FLAKE_TARGET ?= .$(if $(HOSTNAME),#$(HOSTNAME))

# Apply the system configuration, similar to `nixos-rebuild switch`
apply:
	$(call print_banner,⚡ Applying system configuration to $(FLAKE_TARGET)...)
	@nixos apply -y $(FLAKE_TARGET)

# Build a system closure without activating it, and create a symlink to it in the current directory.
# This is equivalent to `nixos-rebuild build`.
build:
	$(call print_banner,⚙️ Building configuration to ./result for $(FLAKE_TARGET)...)
	@nixos apply --no-boot --no-activate --output ./result $(FLAKE_TARGET)

# Build a new configuration but don't activate it. It will be applied on the next reboot.
boot:
	$(call print_banner,🚀 Building configuration for next boot for $(FLAKE_TARGET)...)
	@nixos apply --no-activate -y $(FLAKE_TARGET)

# Clean up old system generations, keeping the last 3 and anything newer than 120 hours.
clean:
	$(call print_banner,🧹 Cleaning up old generations...)
	@nixos generation delete --min 3 --older-than 120h -y

vm:
	$(call print_banner,🖥️ Building VM for $(HOST)...)
	@nix build .#nixosConfigurations.$(HOSTNAME).config.system.build.vm -o ./result/vm
	@./result/vm/bin/run-*-vm

################################################################################
# 🎨 Code Formatting Commands
################################################################################

# Format Nix files with nixfmt
fmt:
	@nixfmt $(FILES)

# Define all phony targets in a single, standard declaration
.PHONY: apply build boot clean fmt
