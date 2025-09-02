{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.steam";
  options = delib.singleEnableOption false;

  nixos.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [steam];
  };

  darwin.ifEnabled = {...}: {
    myconfig.programs.homebrew = {
      enable = true;
      additionalCasks = ["steam"];
    };
  };
}
