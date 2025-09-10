{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.eww";
  options = delib.singleEnableOption false;

  home.ifEnabled = {
    programs.eww = {
      enable = true;
      configDir = ./config;
    };
  };

  nixos.ifEnabled = {
    environment.systemPackages = with pkgs; [eww];
  };
}
