{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.thefuck";
  options = delib.singleEnableOption false;

  home.ifEnabled = {...}: {
    programs.thefuck.enable = true;
  };

  darwin.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [thefuck];
  };

  nixos.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [thefuck];
  };
}
