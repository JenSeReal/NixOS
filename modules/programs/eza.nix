{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.eza";
  options = delib.singleEnableOption false;

  home.ifEnabled = {...}: {
    programs.eza.enable = true;
  };

  darwin.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [eza];
  };

  nixos.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [eza];
  };
}
