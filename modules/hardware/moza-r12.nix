{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "hardware.moza-r12";
  options = delib.singleEnableOption false;

  nixos.ifEnabled = {...}: {
    myconfig = {
      programs.boxflat = {
        enable = true;
        package = pkgs.unstable.boxflat;
      };

      user.extraGroups = ["input"];
    };
  };
}
