{
  delib,
  pkgs,
  lib,
  ...
}:
delib.module {
  name = "programs.doas";
  options = delib.singleEnableOption false;

  nixos.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [doas-sudo-shim];
    environment.shellAliases.sudo = lib.getExe pkgs.doas-sudo-shim;
    security = {
      sudo.enable = false;
      doas = {
        enable = true;
        wheelNeedsPassword = false;
        extraRules = [
          {
            groups = ["wheel"];
            keepEnv = true;
            persist = true;
          }
        ];
      };
    };
  };
}
