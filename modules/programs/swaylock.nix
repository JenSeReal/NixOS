{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.swaylock";
  options = delib.singleEnableOption false;

  home.ifEnabled = {
    programs.swaylock = {
      enable = true;
      package = pkgs.swaylock-effects;

      settings = {
        screenshots = true;
        ignore-empty-password = true;
        disable-caps-lock-text = true;
        grace = 10;

        clock = true;
        timestr = "%R";
        datestr = "%a, %e of %B";

        fade-in = "0.2";

        effect-blur = "10x2";
        effect-scale = "0.1";

        indicator = true;
        indicator-radius = 240;
        indicator-thickness = 20;
        indicator-caps-lock = true;
      };
    };
  };

  nixos.ifEnabled = {
    environment.systemPackages = with pkgs; [swaylock-effects];
    security.pam.services.swaylock = {
      text = ''
        auth sufficient pam_unix.so try_first_pass likeauth nullok
        auth sufficient pam_fprintd.so
        auth include login
      '';
    };
  };
}
