{
  delib,
  lib,
  pkgs,
  ...
}:
delib.module {
  name = "nix";

  nixos.always = {myconfig, ...}: {
    documentation = {
      doc.enable = false;
      info.enable = false;
      man.enable = lib.mkDefault true;
      man.generateCaches = lib.mkDefault true;
      nixos = {
        enable = true;
        options = {
          warningsAreErrors = true;
          splitBuild = true;
        };
      };
    };

    environment.systemPackages = with pkgs; [
      nix-prefetch-git
    ];

    nix = {
      package = pkgs.lixPackageSets.stable.lix;
      checkConfig = true;
      distributedBuilds = true;

      gc = lib.mkIf (!myconfig.programs.nh.enable) {
        automatic = true;
        options = "--delete-older-than 2d";
      };

      # optimise.automatic = true;

      settings = {
        # NixOS-specific settings
        auto-optimise-store = true;
        auto-allocate-uids = true;
        connect-timeout = 5;
        use-cgroups = true;

        allowed-users = [
          "root"
          "@wheel"
          "nix-builder"
          myconfig.constants.username
        ];
        allow-import-from-derivation = true;
        builders-use-substitutes = true;
        experimental-features = [
          "auto-allocate-uids"
          "flakes"
          "nix-command"
          # "pipe-operators"
          "cgroups"
        ];
        fallback = true;
        http-connections = 50;
        keep-derivations = true;
        keep-going = true;
        keep-outputs = true;
        log-lines = 50;
        preallocate-contents = true;
        sandbox = true;
        trusted-users = [
          "root"
          "@wheel"
          "nix-builder"
          myconfig.constants.username
        ];
        warn-dirty = false;
        use-xdg-base-directories = true;

        substituters = [
          "https://cache.nixos.org"
          "https://nix-community.cachix.org"
          "https://nixpkgs-unfree.cachix.org"
          "https://numtide.cachix.org"
          "https://anyrun.cachix.org"
          "https://nix-gaming.cachix.org"
          "https://nixpkgs-wayland.cachix.org"
          "https://hyprland.cachix.org"
        ];

        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
          "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
          "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
          "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
          "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        ];
      };
    };
  };

  darwin.always = {myconfig, ...}: {
    documentation = {
      doc.enable = false;
      info.enable = false;
      man.enable = lib.mkDefault true;
    };

    environment.systemPackages = with pkgs; [
      nix-prefetch-git
    ];

    nix = {
      # package = pkgs.lixPackageSets.stable.lix;
      checkConfig = true;
      distributedBuilds = true;

      gc = lib.mkIf (!myconfig.programs.nh.enable) {
        automatic = true;
        options = "--delete-older-than 2d";
        interval = [
          {
            Hour = 3;
            Minute = 15;
            Weekday = 1;
          }
        ];
      };

      optimise = {
        automatic = true;
        interval = [
          {
            Hour = 4;
            Minute = 15;
            Weekday = 1;
          }
        ];
      };
      extraOptions = ''
        connect-timeout = 5
        keep-going = true
      '';
    };

    nix.settings = {
      ssl-cert-file = "/etc/nix/ca_cert.pem";
      build-users-group = "nixbld";
      extra-sandbox-paths = [
        "/System/Library/Frameworks"
        "/System/Library/PrivateFrameworks"
        "/usr/lib"
        "/private/tmp"
        "/private/var/tmp"
        "/usr/bin/env"
      ];
      http-connections = lib.mkForce 25;
      sandbox = lib.mkForce "relaxed";

      allowed-users = [
        "root"
        "@wheel"
        "nix-builder"
        myconfig.constants.username
      ];
      allow-import-from-derivation = true;
      builders-use-substitutes = true;
      experimental-features = [
        "auto-allocate-uids"
        "flakes"
        "nix-command"
        "pipe-operators"
      ];
      fallback = true;
      keep-derivations = true;
      keep-going = true;
      keep-outputs = true;
      log-lines = 50;
      preallocate-contents = true;
      trusted-users = [
        "root"
        "@wheel"
        "nix-builder"
        myconfig.constants.username
      ];
      warn-dirty = false;
      use-xdg-base-directories = true;

      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://nixpkgs-unfree.cachix.org"
        "https://numtide.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
        "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
      ];
    };
  };
}
