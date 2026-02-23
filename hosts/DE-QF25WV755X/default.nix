{delib, ...}:
delib.host {
  name = "DE-QF25WV755X";

  myconfig = {
    features = {
      desktop-environments.aerospace.enable = true;
      shell-tools.enable = true;
    };

    programs = {
      citrix-workspace.enable = true;
      codium.enable = true;
      firefox.enable = true;
      fish.enable = true;
      gimp.enable = true;
      nh.enable = true;
      nu.enable = true;
      wezterm.enable = true;
      zed.enable = true;
      zsh.enable = true;
    };
  };
}
