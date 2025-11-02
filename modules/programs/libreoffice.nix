{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.libreoffice";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.libreoffice-qt;
    };

  nixos.ifEnabled = {cfg, ...}: {
    environment.systemPackages = with pkgs; [
      cfg.package
      hyphenDicts.de_DE
      hunspell
      hunspellDicts.de_DE
      hunspellDicts.en_US
    ];
  };
}
