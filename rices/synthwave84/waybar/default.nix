{delib, ...}:
delib.rice {
  name = "synthwave84";

  home = {...}: let
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
