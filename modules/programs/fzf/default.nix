{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.fzf";
  options = delib.singleEnableOption false;

  home.ifEnabled = {...}: {
    programs.fzf.enable = true;
  };

  darwin.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [fzf];
  };

  nixos.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [fzf];
  };
}
