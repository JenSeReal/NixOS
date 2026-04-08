{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.zsh";
  options = delib.singleEnableOption false;

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

  home.ifEnabled = {...}: {
    programs.zsh = {
      enable = true;
      autocd = true;
      autosuggestion.enable = true;
    };
  };
}
