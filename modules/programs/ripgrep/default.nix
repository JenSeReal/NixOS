{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.ripgrep";
  options = delib.singleEnableOption false;

  home.ifEnabled = {...}: {
    programs.ripgrep.enable = true;
  };

  darwin.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [ripgrep];
  };

  nixos.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [ripgrep];
  };
}
