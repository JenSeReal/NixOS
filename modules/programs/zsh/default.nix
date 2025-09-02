{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.zsh";

  options = with delib;
    moduleOptions {
      enable = boolOption false;
    };
  home.ifEnabled = {...}: {};

  darwin.ifEnabled = {...}: {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      enableFzfCompletion = true;
      enableFzfGit = true;
      enableFzfHistory = true;
      enableSyntaxHighlighting = true;
    };
    environment.shells = [pkgs.zsh];
  };

  nixos.ifEnabled = {...}: {
  };
}
