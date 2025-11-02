{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.ripgrep";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.ripgrep;
    };

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
