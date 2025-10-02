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
      system = prev.system;
    };
  in {
    inherit master;
  };
}
