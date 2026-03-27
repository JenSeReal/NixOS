{delib, ...}: let
  inherit (delib) extension maintainers;
in
  extension {
    name = "packages";
    description = "Provides delib.package for defining custom packages (similar to delib.host)";
    maintainers = with maintainers; [JenSeReal];

    libExtension = config: final: _: {
      # Define a package with delib.package - similar to delib.host
      # Usage:
      #   delib.package {
      #     name = "my-package";
      #     package = {lib, pkgs, fetchFromGitHub, ...}: pkgs.stdenv.mkDerivation { ... };
      #   }
      package = {
        name,
        package,
      }: let
        pkgsOverlay = pkgsFinal: pkgsPrev: {
          ${name} = pkgsFinal.callPackage package {};
        };
      in
        final.module {
          name = "packages.${name}";

          nixos.always.nixpkgs.overlays = [pkgsOverlay];
          darwin.always.nixpkgs.overlays = [pkgsOverlay];
        };
    };
  }
