{delib, ...}:
delib.overlayModule {
  name = "lix";
  overlay = final: prev: {
    inherit
      (final.lixPackageSets.stable)
      nixpkgs-review
      # nix-direnv  # causes infinite recursion with lixPackageSets
      nix-eval-jobs
      nix-fast-build
      colmena
      ;
  };
}
