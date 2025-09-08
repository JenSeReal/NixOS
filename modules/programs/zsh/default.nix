{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.zsh";
  options = delib.singleEnableOption false;

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
}
