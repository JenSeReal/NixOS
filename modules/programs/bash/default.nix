{delib, ...}:
delib.module {
  name = "programs.bash";

  options = with delib;
    moduleOptions {
      enable = boolOption false;
    };

  home.ifEnabled = {...}: {};

  darwin.ifEnabled = {...}: {
    programs.bash = {
      enable = true;
      completion.enable = false;
    };
  };

  nixos.ifEnabled = {...}: {
  };
}
