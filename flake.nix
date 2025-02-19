{
  description = "JenSeReals flake repository";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-24.11-darwin";
    flake-parts.url = "github:hercules-ci/flake-parts";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      # url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # nixos-hardware.url = "github:NixOS/nixos-hardware/083823b7904e43a4fc1c7229781417e875359a42";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fw-ectool = {
      url = "github:tlvince/ectool.nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    impermanence.url = "github:nix-community/impermanence";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ragenix.url = "github:yaxitech/ragenix";

    darwin.url = "github:LnL7/nix-darwin/nix-darwin-24.11";
    darwin.inputs.nixpkgs.follows = "nixpkgs-darwin";
    mac-app-util = {
      url = "github:hraban/mac-app-util";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    snowfall-frost = {
      url = "github:snowfallorg/frost";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake = {
      url = "github:snowfallorg/flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs-unstable";
    devenv.url = "github:cachix/devenv";
    devenv.inputs.nixpkgs.follows = "nixpkgs-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs-unstable";
    # wezterm.url = "github:wez/wezterm/main?dir=nix";
    # wezterm.inputs.nixpkgs.follows = "nixpkgs-unstable";

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix-vscode-extensions.inputs.nixpkgs.follows = "nixpkgs-unstable";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    vscode-server.inputs.nixpkgs.follows = "nixpkgs-unstable";

    anyrun.url = "github:anyrun-org/anyrun";
    anyrun-nixos-options.url = "github:n3oney/anyrun-nixos-options";

    typst-live.url = "github:ItsEthra/typst-live";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix/master";
  };

  outputs =
    { self, ... }@inputs:
    let
      inherit inputs;

      lib = inputs.snowfall-lib.mkLib {
        inherit inputs;
        src = ./.;

        snowfall = {
          meta = {
            name = "JenSeReal";
            title = "JenSeReal";
          };

          namespace = "JenSeReal";
        };
      };
    in
    lib.mkFlake {
      outputs-builder = channels: {
        formatter = channels.nixpkgs.alejandra;
      };

      channels-config = {
        allowUnfree = true;
        permittedInsecurePackages = [ ];
      };

      overlays = with inputs; [
        flake.overlays.default
        nur.overlays.default
        snowfall-frost.overlays.default
        rust-overlay.overlays.default
      ];

      systems = {
        modules = {
          darwin = with inputs; [
            home-manager.darwinModules.home-manager
            nix-homebrew.darwinModules.nix-homebrew
            nixvim.nixDarwinModules.nixvim
            stylix.darwinModules.stylix
            mac-app-util.darwinModules.default
            ragenix.darwinModules.default
          ];

          home = with inputs; [
            anyrun.homeManagerModules.anyrun-with-all-plugins
            nixvim.homeManagerModules.nixvim
            sops-nix.homeManagerModules.sops
            ragenix.homeManagerModules.default
            vscode-server.homeModules.default
            stylix.homeManagerModules.stylix
          ];

          nixos = with inputs; [
            home-manager.nixosModules.home-manager
            vscode-server.nixosModules.default
            lanzaboote.nixosModules.lanzaboote
            sops-nix.nixosModules.sops
            ragenix.nixosModules.default
            stylix.nixosModules.stylix
          ];
        };
      };

      templates = {
        default = {
          path = ./templates/default;
          description = "A very basic flake for dev environments";
        };
      };

      defaultTemplate = self.templates.default;
    };
}
