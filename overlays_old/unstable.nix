{
  inputs,
  delib,
  ...
}:
delib.overlayModule {
  name = "unstable";
  overlay = final: prev: let
    inherit (final) config;
    unstable = import inputs.nixpkgs-unstable {
      inherit config;
      system = prev.system;
    };
  in {
    inherit unstable;
  };
}
