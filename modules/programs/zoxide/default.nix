{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.zoxide";
  options = delib.singleEnableOption false;

  home.ifEnabled = {...}: {
    programs.zoxide.enable = true;
  };

  darwin.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [zoxide];
  };

  nixos.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [zoxide];
  };
}
