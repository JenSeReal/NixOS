{
  delib,
  pkgs,
  lib,
  ...
}:
delib.module {
  name = "programs.sudo";
  options = delib.singleEnableOption false;

  nixos.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [doas-sudo-shim];
    environment.shellAliases.sudo = lib.getExe pkgs.doas-sudo-shim;
    security = {
      doas.enable = false;
      sudo = {
        enable = true;
        wheelNeedsPassword = false;
      };
    };
  };
}
