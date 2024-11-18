{
  lib,
  namespace,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib.${namespace}) enabled;
in
{
  imports = [ inputs.ragenix.darwinModules.default ];

  environment.systemPackages = with pkgs; [
    vscode
    git
    lazygit
    pciutils
    eza
    bat
    fd
    du-dust
    delta
    rm-improved
    ripgrep
    fzf
    zoxide
    killall
    btop
    cyberchef
    discord
    wget
    jetbrains.idea-community-bin
    # gimp
    # inkscape
    act
    postman
    devenv
    seabird
  ];

  JenSeReal = {
    desktop.environments.aerospace = enabled;
    programs.cli = {
      direnv = enabled;
      homebrew = enabled;
      ragenix = enabled;
    };
    programs.gui = {
      browsers.arc = enabled;
      logseq = enabled;
      miro = enabled;
      headlamp = enabled;
      entertainment.music.spotify = enabled;
      entertainment.gaming.steam = enabled;
    };
    system.nix = enabled;
    virtualisation.docker = enabled;
  };
}
