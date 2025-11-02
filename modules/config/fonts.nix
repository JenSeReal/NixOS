{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "fonts";

  darwin.always = {
    fonts.packages = [pkgs.sketchybar-app-font];

    system = {
      defaults = {
        NSGlobalDomain = {
          AppleFontSmoothing = 1;
        };
      };
    };
  };

  nixos.always = {
    environment.variables = {
      LOG_ICONS = "true";
    };

    environment.systemPackages = with pkgs; [
      fontpreview
    ];
    fonts.fontDir.enable = true;
  };
}
