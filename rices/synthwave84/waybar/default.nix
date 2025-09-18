{delib, ...}:
delib.module {
  name = "programs.waybar";

  home.ifEnabled = {...}: let
    style = builtins.readFile ./styles.css;
    synthwave84 = builtins.readFile ./synthwave84.css;
  in {
    programs.waybar = {
      enable = true;
      style = ''
        ${style}

        ${synthwave84}
      '';
    };
  };
}
