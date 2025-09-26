# nix-config

> ⚡️ Personal NixOS configuration repo, powered by flakes. Modular, reproducible, and easy to maintain, I guess xD.

## Overview

This repository contains my NixOS system configuration, designed for modularity and reproducibility using [Nix flakes](https://nixos.wiki/wiki/Flakes). All system, host, and app definitions are organized for flexibility and maintainability.

## Structure

- **flake.nix / flake.lock:** Flake entry point and lockfile for reproducibility.
- **default.nix / imports.nix:** Core configuration and module imports.
- **nix/apps/**: Modules for individual applications and tools.
- **nix/hosts/**: Host-specific system configurations.
- **nix/defaultTags.nix:** Default tag definitions for config modularity.

## Getting Started

### Prerequisites

- [Nix](https://nixos.org/download.html) installed
- Flakes enabled (`nix.conf: experimental-features = nix-command flakes`)
- Git

### Clone and Apply

```sh
git clone https://github.com/declnix/nix-config.git
cd nix-config
sudo nixos-rebuild switch --flake .#<hostname>
```
Replace `<hostname>` with your target host as defined in `hosts/`.

## Usage

- **Rebuild system:**  
  `sudo nixos-rebuild switch --flake .#<hostname>`
- **Test config changes:**  
  `sudo nixos-rebuild test --flake .#<hostname>`
- **Regenerate macros:**  
  `nix run ".#eval-macros"`
- **Apps/modules:**  
  Find and edit individual app modules in `apps/`.
- **Hosts:**  
  Find and edit host-specific configs in `hosts/`.

## Credits

Special thanks to [@chadac](https://github.com/chadac) for his work on [nix-config-modules](https://github.com/chadac/nix-config-modules), which inspired and informed the structure and modularity of this repository.

## Contributing

PRs and issues are welcome. For major changes, please open an issue first to discuss your ideas.

## License

[MIT](LICENSE)