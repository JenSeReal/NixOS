{
  config,
  inputs,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkDefault;
  inherit (lib.types) package;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.system.nix;

  users = [
    "root"
    "@wheel"
    "nix-builder"
    config.${namespace}.user.name
  ];
in {
  options.${namespace}.system.nix = {
    enable = mkEnableOption "Whether or not to manage nix configuration.";
    package = mkOpt package pkgs.nixVersions.latest "Which nix package to use.";
  };

  config = mkIf cfg.enable {
    # faster rebuilding
    documentation = {
      doc.enable = false;
      info.enable = false;
      man.enable = mkDefault true;
    };

    environment = {
      systemPackages = with pkgs; [
        cachix
        git
        nix-prefetch-git
      ];
    };

    nix = let
      mappedRegistry = lib.pipe inputs [
        (lib.filterAttrs (_: lib.isType "flake"))
        (lib.mapAttrs (_: flake: {inherit flake;}))
        (x: x // (lib.mkIf pkgs.stdenv.isLinux {nixpkgs.flake = inputs.nixpkgs;}))
      ];
    in {
      inherit (cfg) package;

      distributedBuilds = true;

      gc = {
        automatic = true;
        options = "--delete-older-than 2d";
      };

      # This will additionally add your inputs to the system's legacy channels
      # Making legacy nix commands consistent as well
      nixPath = lib.mapAttrsToList (key: _: "${key}=flake:${key}") config.nix.registry;

      optimise = {
        automatic = true;
      };

      # pin the registry to avoid downloading and evaluating a new nixpkgs version every time
      # this will add each flake input as a registry to make nix3 commands consistent with your flake
      registry = mappedRegistry;

      settings = {
        allowed-users = users;
        allow-import-from-derivation = true;
        builders-use-substitutes = true;
        download-buffer-size = 524288000;
        experimental-features = [
          "nix-command"
          "flakes"
          "recursive-nix"
        ];
        flake-registry = "/etc/nix/registry.json";
        http-connections = 50;
        keep-derivations = true;
        keep-going = true;
        keep-outputs = true;
        log-lines = 50;
        sandbox = true;
        trusted-users = users;
        warn-dirty = false;

        substituters = [
          "https://cache.nixos.org"
          "https://nix-community.cachix.org"
          "https://hyprland.cachix.org"
          "https://nixpkgs-unfree.cachix.org"
          "https://numtide.cachix.org"
        ];

        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
          "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
        ];

        use-xdg-base-directories = true;
      };
    };
  };
}
