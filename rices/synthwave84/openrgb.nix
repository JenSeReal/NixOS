{
  delib,
  pkgs,
  ...
}:
delib.rice {
  name = "synthwave84";

  home = {
    systemd.user.services.openrgb-theme = {
      Unit = {
        Description = "Set OpenRGB to synthwave84 colors";
        After = ["graphical-session.target"];
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.openrgb-with-all-plugins}/bin/openrgb --color ff6ac1";
        RemainAfterExit = true;
      };
      Install.WantedBy = ["graphical-session.target"];
    };
  };
}
