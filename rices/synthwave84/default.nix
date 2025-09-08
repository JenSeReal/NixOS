{delib, ...}: let
  common = {
    enable = true;
    image = ./P13_Background1.png;
    base16Scheme = ./synthwave84.yaml;
  };
in
  delib.rice {
    name = "synthwave84";

    nixos = common // {};

    darwin = common // {};
  }
