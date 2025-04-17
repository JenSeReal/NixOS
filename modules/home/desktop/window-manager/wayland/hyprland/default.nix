{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.JenSeReal;
let

  cfg = config.JenSeReal.desktop.window-managers.hyprland;
in
{
  options.JenSeReal.desktop.window-managers.hyprland = {
    enable = mkEnableOption "Hyprland.";
    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = ''
        Extra configuration lines to add to `~/.config/hypr/hyprland.conf`.
      '';
    };
  };

  imports = [
    ./autostart.nix
    ./look.nix
    ./feel.nix
    ./input.nix
    ./output.nix
    ./bindings.nix
    ./window-rules.nix
    ./workspace.nix
  ];

  config = mkIf cfg.enable {
    programs.waybar.systemd.target = "hyprland-session.target";

    wayland.windowManager.hyprland = {
      enable = true;

      extraConfig = ''
        env = XDG_DATA_DIRS,'${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}':$XDG_DATA_DIRS
        env = HYPRLAND_TRACE,1

        ${cfg.extraConfig}
      '';

      settings = {
        exec = [ ''notify-send -i ~/.face -u normal -t 5000 "Hello $(whoami)"'' ];
      };
    };
  };
}
