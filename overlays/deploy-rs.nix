{
  inputs,
  delib,
  ...
}:
delib.overlayModule {
  name = "deploy-rs";
  overlay = final: prev: {
    # Use deploy-rs from the flake input to get the lib functions,
    # but overlay it to use the deploy-rs package from nixpkgs binary cache
    deploy-rs = {
      inherit (inputs.deploy-rs.packages.${prev.stdenv.hostPlatform.system}) deploy-rs;
      lib = inputs.deploy-rs.lib;
    };
  };
}
