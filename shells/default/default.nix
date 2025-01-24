{
  pkgs,
  inputs,
  lib,
  ...
}:

inputs.devenv.lib.mkShell {
  inherit inputs pkgs;

  modules = [
    {
      name = "Basic development shell";
      dotenv.disableHint = true;

      languages = {
        nix.enable = true;
        nix.lsp.package = pkgs.nixd;
      };

      # processes.biome = {
      #   exec = "${lib.getExe pkgs.biome} start";
      #   process-compose = {
      #     is_daemon = true;
      #     shutdown = {
      #       command = "${lib.getExe pkgs.biome} stop";
      #     };
      #     availability = {
      #       restart = "on_failure";
      #     };
      #   };
      # };

      packages =
        [
          pkgs.hydra-check
          pkgs.nix-diff
          pkgs.nix-index
          pkgs.nix-prefetch-git
          pkgs.nixfmt-rfc-style
          pkgs.nixpkgs-hammering
          pkgs.nixpkgs-lint
          pkgs.snowfallorg.flake
          pkgs.snowfallorg.frost
          pkgs.jemalloc
          pkgs.biome
        ]
        ++ lib.optionals pkgs.stdenv.isDarwin (
          with pkgs.darwin.apple_sdk.frameworks;
          [
            Cocoa
            CoreFoundation
            CoreServices
            Security
          ]
        );

      enterShell = ''
        [ ! -f .env ] || export $(grep -v '^#' .env | xargs)
      '';
    }
  ];
}
