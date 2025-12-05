{
  inputs,
  delib,
  ...
}:
delib.overlayModule {
  name = "master";
  overlay = final: prev: let
    inherit (final) config;
    master = import inputs.nixpkgs-master {
      inherit config;
      system = prev.stdenv.hostPlatform.system;
    };
  in {
    inherit master;
  };
}
