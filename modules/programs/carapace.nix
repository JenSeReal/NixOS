{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.carapace";
  options = delib.singleEnableOption false;

  home.ifEnabled = {...}: {
    programs.carapace.enable = true;
  };

  nixos.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [carapace];
  };
}
