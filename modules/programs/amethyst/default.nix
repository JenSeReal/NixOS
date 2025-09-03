{delib, ...}:
delib.module {
  name = "programs.amethyst";

  options = delib.singleEnableOption false;

  darwin.ifEnabled = {...}: {
    myconfig.programs.homebrew = {
      enable = true;
      additionalCasks = ["amethyst"];
    };

    # home.configFile."amethyst/amethyst.yml".source = ./amethyst.yml;
  };
}
