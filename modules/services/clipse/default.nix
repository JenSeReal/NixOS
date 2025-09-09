{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "services.clipcat";
  options = delib.singleEnableOption false;

  home.ifEnabled = {...}: {
    services.clipse.enable = true;
  };

  nixos.ifEnabled = {
    environment.systemPackages = with pkgs; [clipse];
  };
}
