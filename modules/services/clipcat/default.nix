{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "services.clipcat";
  options = delib.singleEnableOption false;

  home.ifEnabled = {...}: {
    home.packages = [pkgs.skim];

    services.clipcat = {
      enable = true;
      menuSettings = {
        finder = "skim";
      };
    };
  };

  nixos.ifEnabled = {
    environment.systemPackages = with pkgs; [clipcat];
  };
}
