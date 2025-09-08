{
  delib,
  pkgs,
  ...
}: let
  common = {environment.systemPackages = [pkgs.starship];};
in
  delib.module {
    name = "programs.starship";
    options = delib.singleEnableOption false;

    darwin.ifEnabled = common // {};

    home.ifEnabled = {...}: {
      programs.starship.enable = true;
    };

    nixos.ifEnabled = common // {};
  }
