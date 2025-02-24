{ channels, ... }:
final: prev: {
  biome = channels.nixpkgs-unstable.biome.overrideAttrs (old: {
    doCheck = false;
    doInstallCheck = false;
  });
}
