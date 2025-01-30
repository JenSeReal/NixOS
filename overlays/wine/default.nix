{ channels, ... }:
final: prev: {
  inherit (channels.nixpkgs-unstable) wine wineWowPackages;
}
