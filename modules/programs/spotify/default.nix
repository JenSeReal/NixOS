{
  delib,
  pkgs,
  ...
}: let
  common = {
    environment.systemPackages = with pkgs; [spotify];
  };
in
  delib.module {
    name = "programs.spotify";
    options = delib.singleEnableOption false;

    nixos.ifEnabled = {...}: common // {};

    darwin.ifEnabled = {...}: common // {};
  }
