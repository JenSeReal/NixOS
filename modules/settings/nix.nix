{
  delib,
  lib,
  pkgs,
  ...
}: let
  shared = {myconfig, ...}: {
    documentation = {
      doc.enable = false;
      info.enable = false;
      man.enable = lib.mkDefault true;
    };

    environment = {
      systemPackages = with pkgs; [
        cachix
        git
        nix-prefetch-git
      ];
    };

    nix = {
      checkConfig = true;

      distributedBuilds = true;

      gc = {
        automatic = true;
        options = "--delete-older-than 2d";
      };

      optimise.automatic = true;

      settings = {
        allowed-users = [
          "root"
          "@wheel"
          "nix-builder"
          myconfig.constants.username
        ];
        allow-import-from-derivation = true;
        builders-use-substitutes = true;
        download-buffer-size = 500000000;
        experimental-features = [
          "nix-command"
          "flakes"
          "ca-derivations"
          "auto-allocate-uids"
          "pipe-operators"
          "dynamic-derivations"
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
in
  delib.module {
    name = "settings.nix";

    nixos.always = {
      cfg,
      myconfig,
      ...
    }:
      lib.recursiveUpdate
      (shared {inherit cfg myconfig;})
      {
        documentation = {
          man.generateCaches = lib.mkDefault true;

          nixos = {
            enable = true;

            options = {
              warningsAreErrors = true;
              splitBuild = true;
            };
          };
        };
        nix = {
          daemonCPUSchedPolicy = "batch";
          daemonIOSchedClass = "idle";
          daemonIOSchedPriority = 7;

          gc = {
            dates = "Sun *-*-* 03:00";
          };

          optimise = {
            automatic = true;
            dates = ["04:00"];
          };

          settings = {
            auto-allocate-uids = true;
            connect-timeout = 5;
            experimental-features = ["cgroups"];
            use-cgroups = true;

            substituters = [
              "https://anyrun.cachix.org"
              "https://hyprland.cachix.org"
              "https://nix-gaming.cachix.org"
              "https://nixpkgs-wayland.cachix.org"
            ];
            trusted-public-keys = [
              "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
              "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
              "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
              "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
            ];
          };
        };
      };

    darwin.always = {
      cfg,
      myconfig,
      ...
    }:
      lib.recursiveUpdate
      (shared {inherit cfg myconfig;})
      {
        nix = {
          settings = {
            ssl-cert-file = "/etc/nix/ca_cert.pem";
          };
          extraOptions = ''
            # bail early on missing cache hits
            connect-timeout = 5
            keep-going = true
          '';

          gc.interval = [
            {
              Hour = 3;
              Minute = 15;
              Weekday = 1;
            }
          ];

          optimise.interval = [
            {
              Hour = 4;
              Minute = 15;
              Weekday = 1;
            }
          ];

          settings = {
            build-users-group = "nixbld";

            extra-sandbox-paths = [
              "/System/Library/Frameworks"
              "/System/Library/PrivateFrameworks"
              "/usr/lib"

              "/private/tmp"
              "/private/var/tmp"
              "/usr/bin/env"
            ];

            # Frequent issues with networking failures on darwin
            # limit number to see if it helps
            http-connections = lib.mkForce 25;

            # FIXME: upstream bug needs to be resolved before fully enabling
            # https://github.com/NixOS/nix/issues/12698
            sandbox = lib.mkForce "relaxed";
          };
        };
      };
  }
