{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.bat";
  options = delib.singleEnableOption false;

  home.ifEnabled = {...}: {
    programs.bat.enable = true;
  };

  darwin.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [bat];
  };

  nixos.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [bat];
  };
}
