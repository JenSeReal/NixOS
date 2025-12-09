# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a modular NixOS, Home Manager, and nix-darwin configuration using the Denix framework. It supports multiple platforms (NixOS, macOS via nix-darwin) with a unified configuration approach.

## Build and Deployment Commands

### NixOS
```bash
# Build and activate system configuration
sudo nixos-rebuild switch --flake .

# Build without activating
sudo nixos-rebuild build --flake .

# Build for a specific host
sudo nixos-rebuild switch --flake .#jens-pc
```

### macOS (nix-darwin)
```bash
# Initial installation
nix run nix-darwin -- switch --flake .

# After initial setup
darwin-rebuild switch --flake .
```

### Home Manager (standalone)
```bash
# Build and activate home configuration
home-manager switch --flake .
```

### Using nh (Nix Helper)
This repository enables `nh` which provides improved rebuilding:
```bash
# NixOS rebuild with better output
nh os switch

# Home Manager rebuild
nh home switch
```

## Development and Testing

### Checking flake
```bash
# Validate flake syntax
nix flake check

# Show flake metadata
nix flake metadata

# Update all inputs
nix flake update

# Update specific input
nix flake lock --update-input nixpkgs
```

### Build testing
```bash
# Build specific configuration output
nix build .#nixosConfigurations.jens-pc.config.system.build.toplevel

# Build home configuration
nix build .#homeConfigurations.jfp@jens-pc.activationPackage
```

## Architecture

### Denix Framework
This repository uses [Denix](https://github.com/yunfachi/denix), a modular configuration framework that provides:
- `delib.module`: Creates modules with unified options for nixos/home/darwin
- `delib.host`: Defines host configurations with rice and type attributes
- `delib.rice`: Defines theming/appearance configurations
- `delib.overlayModule`: Creates package overlays
- Extensions system for custom functionality

### Directory Structure

- **flake.nix**: Main entry point, defines configurations via `mkConfigurations` helper
- **hosts/**: Host-specific configurations
  - `hosts/<hostname>/default.nix`: Uses `delib.host` to define host with rice, type, and enabled modules
  - `hosts/<hostname>/hardware-configuration.nix`: Auto-generated hardware config
  - `hosts/common/`: Shared host configurations
- **modules/**: Modular system/home configurations organized by category
  - `modules/config/`: System configuration (audio, boot, fonts, networking, etc.)
  - `modules/hardware/`: Hardware-specific modules (bluetooth, Framework laptop, peripherals)
  - `modules/programs/`: Application configurations
  - `modules/services/`: Service configurations
  - `modules/desktop-environments/`: Desktop environment modules (Hyprland, etc.)
  - `modules/libraries/`: Library configurations (Qt, etc.)
- **rices/**: Theming configurations (currently `synthwave84`)
- **packages/**: Custom package definitions
  - Each package in `packages/<name>/package.nix` is automatically registered
  - Uses custom `packageModule` extension for cross-platform package registration
- **overlays/**: Package overlays (unstable, master, firefox-addons, etc.)
  - Provides access to different nixpkgs versions (unstable, master, darwin-specific)
- **extensions/**: Denix extensions that add custom functionality
  - `package-module.nix`: Auto-registers packages from packages/ directory

### Module System Pattern

Modules use Denix's unified structure:
```nix
delib.module {
  name = "programs.example";
  options = with delib; moduleOptions {
    enable = boolOption false;
    package = packageOption pkgs.example;
  };

  nixos.ifEnabled = {cfg, ...}: { /* NixOS config */ };
  darwin.ifEnabled = {cfg, ...}: { /* macOS config */ };
  home.ifEnabled = {cfg, ...}: { /* Home Manager config */ };
}
```

- `nixos.*` = NixOS configuration
- `darwin.*` = macOS/nix-darwin configuration
- `home.*` = Home Manager configuration
- `.ifEnabled` = Applied only when module is enabled
- `.always` = Always applied regardless of enable state

### Package Registration

Custom packages in `packages/` follow this pattern:
```nix
# packages/<name>/package.nix
{ lib, stdenv, ... }: stdenv.mkDerivation { ... }

# packages/<name>/default.nix
{ delib, ... }:
delib.packageModule {
  name = "package-name";
  package = ./package.nix;
}
```

The package is automatically:
1. Built via overlay on all platforms
2. Registered as a module at `myconfig.programs.<name>`
3. Platform compatibility handled via `meta.platforms`

### Flake Structure

The main flake uses:
- `mkConfigurations`: Helper that scans paths and creates nixos/home/darwin configurations
- Automatic module discovery from `./modules`, excluding `modules/` and `types/` subdirectories
- Custom extensions from `./extensions` to add functionality like package registration
- Special args include `inputs` and `moduleSystem` for module-specific logic

## Secrets Management

This repository uses sops-nix for secrets:

```bash
# Create new secret file
nix-shell -p sops --run "sops hosts/jens-pc/secrets/example.yml"

# Convert SSH key to age key
sudo nix-shell -p ssh-to-age --run "ssh-to-age -private-key -i /etc/ssh/ssh_host_ed25519_key > ~/.config/sops/age/keys.txt"

# Get age public key from age key
nix-shell -p age --run "age-keygen -y ~/.config/sops/age/keys.txt"
```

Secrets are configured in `.sops.yaml` with per-host encryption keys.

## Initial Installation (NixOS)

See `bootstrap/README.md` for detailed installation instructions. Key steps:
1. Disable secure boot
2. Run install script: `curl -sSL https://raw.githubusercontent.com/JenSeReal/NixOS/main/bootstrap/install.sh -o install.sh; sh install.sh`
3. Adapt hardware-configuration.nix
4. Install with `sudo nixos-install`
5. Create secure boot keys: `sudo nix run nixpkgs#sbctl create-keys`
6. Rebuild and enroll keys

## Key Inputs and Dependencies

- **nixpkgs**: NixOS 25.11 stable channel
- **nixpkgs-unstable**: Rolling release packages (accessible via `pkgs.unstable.*`)
- **home-manager**: User environment management
- **nix-darwin**: macOS system management
- **denix**: Configuration framework providing modular abstractions
- **stylix**: System-wide theming
- **sops-nix**: Secrets management
- **lanzaboote**: Secure Boot support
- **nixos-hardware**: Hardware-specific configurations
- **hyprland-contrib**: Hyprland compositor tools
- **nvf**: Neovim configuration framework

## Common Patterns

### Adding a new module
1. Create `modules/<category>/<name>.nix` using `delib.module`
2. Define options with `moduleOptions`
3. Configure platform-specific behavior in `nixos.*`, `darwin.*`, `home.*` blocks
4. Enable in host config: `myconfig.<category>.<name>.enable = true`

### Adding a new host
1. Create `hosts/<hostname>/default.nix` using `delib.host`
2. Set `name`, `rice`, and `type` attributes
3. Enable desired modules in `myconfig` section
4. Add hardware-configuration.nix (auto-generated or manually created)

### Adding a custom package
1. Create `packages/<name>/package.nix` with derivation
2. Create `packages/<name>/default.nix` using `delib.packageModule`
3. Package is automatically available as `pkgs.<name>` and `myconfig.programs.<name>`

### Using different nixpkgs versions
- Stable: `pkgs.package-name`
- Unstable: `pkgs.unstable.package-name`
- Master: `pkgs.master.package-name`
- Darwin-specific: Uses `nixpkgs-darwin` input for macOS
