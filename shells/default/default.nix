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

      packages = with pkgs;
        [
          hydra-check
          nix-diff
          nix-index
          nix-prefetch-git
          nixfmt-rfc-style
          nixpkgs-hammering
          nixpkgs-lint
          snowfallorg.flake
          # snowfallorg.frost
          jemalloc
        ]
        ++ lib.optionals pkgs.stdenv.isDarwin [
          apple-sdk_15
        ];

      enterShell = ''
        [ ! -f .env ] || export $(grep -v '^#' .env | xargs)
      '';
    }
  ];
}
