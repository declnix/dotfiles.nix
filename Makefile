# 🚀 System Deployment Commands

HOSTNAME ?= $(shell hostname)
IMPORTS_FILE := imports.nix

# All targets now depend on imports.nix
switch: $(IMPORTS_FILE)
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "> ⚡ Applying system configuration to .#$(HOSTNAME)..."
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@nixos-rebuild switch --flake .#$(HOSTNAME)

build: $(IMPORTS_FILE)
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "> ⚙️ Building configuration to ./result for .#$(HOSTNAME)..."
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@nixos-rebuild build --flake .#$(HOSTNAME)

boot: $(IMPORTS_FILE)
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "> 🚀 Building configuration for next boot for .#$(HOSTNAME)..."
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@nixos-rebuild boot --flake .#$(HOSTNAME)

clean:
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "> 🧹 Cleaning up old generations..."
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@nixos generation delete --min 3 --older-than 120h -y

# 🎨 Code Formatting Commands

fmt:
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "> 🎨 Formatting nix files..."
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@nixfmt "**/*.nix"

# 📦 Generate imports.nix automatically (must be last)
.PHONY: $(IMPORTS_FILE)
$(IMPORTS_FILE):
	@echo "{ " > $(IMPORTS_FILE)
	@echo "  imports = [" >> $(IMPORTS_FILE)
	@grep -rl '# @auto-import' nix | while read f; do \
	    echo "    ./$$f" >> $(IMPORTS_FILE); \
	done
	@echo "  ];" >> $(IMPORTS_FILE)
	@echo "}" >> $(IMPORTS_FILE)
