{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.neovim";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.neovim;
    };

  home.ifEnabled = {cfg, ...}: {
    programs.neovim = {
      enable = true;
      package = cfg.package;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
  };

  darwin.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };

  nixos.ifEnabled = {cfg, ...}: {
    programs.neovim = {
      enable = true;
      package = cfg.package;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
  };
}
