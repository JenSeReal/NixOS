{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.wlroots";
  options = delib.singleEnablxeOption false;

  nixos.ifEnabled = {
    environment.systemPackages = with pkgs; [
      cliphist
      grim
      slurp
      swayimg
      wdisplays
      wf-recorder
      wl-clipboard
      wlr-randr
      brightnessctl
      glib
      gtk3.out
      gtk4
      playerctl
      libsForQt5.qt5.qtwayland
      qt6.qtwayland
    ];

    # JenSeReal = {
    #   cli-apps = {
    #     wshowkeys = enabled;
    #   };

    #   desktop.addons = {
    #     electron-support = enabled;
    #     swappy = enabled;
    #     swaylock = enabled;
    #     swaynotificationcenter = enabled;
    #     wlogout = enabled;
    #   };
    # };

    programs = {
      nm-applet.enable = true;
      xwayland.enable = true;
    };
  };
}
