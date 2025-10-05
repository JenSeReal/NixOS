{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.skim";
  options = delib.singleEnableOption false;

  home.ifEnabled = {...}: {
    programs.skim.enable = true;
  };

  darwin.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [skim];
  };

  nixos.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [skim];
  };
}
