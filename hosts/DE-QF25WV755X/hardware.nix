{delib, ...}:
delib.host {
  name = "DE-QF25WV755X";
  type = "laptop";

  system = "aarch64-darwin";

  home.home.stateVersion = "25.11";

  darwin = {
    system = {
      stateVersion = 6;
      primaryUser = "jfp";
    };
  };
}
