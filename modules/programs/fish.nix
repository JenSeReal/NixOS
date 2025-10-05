{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.fish";
  options = delib.singleEnableOption false;

  darwin.ifEnabled = {...}: {
    programs.fish.enable = true;
    environment.shells = with pkgs; [fish];
  };

  home.ifEnabled = {...}: {
    programs.fish = {
      enable = true;
      shellInit = ''
        ${
          if pkgs.stdenv.isDarwin
          then "set fish_emoji_width 2"
          else ""
        }
      '';
    };
  };

  nixos.ifEnabled = {...}: {
    programs.fish.enable = true;
    environment.shells = with pkgs; [fish];
  };
}
