{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.devenv";
  options = delib.singleEnableOption false;

  darwin.ifEnabled = {...}: {
    myconfig.programs.direnv.enable = true;
    environment.systemPackages = with pkgs; [
      devenv
    ];
  };

  nixos.ifEnabled = {...}: {
  };
}
