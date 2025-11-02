{delib, ...}:
delib.module {
  name = "programs.bash";
  options = delib.singleEnableOption false;

  home.ifEnabled = {...}: {
    programs.bash = {
      enable = true;
      completion.enable = false;
    };
  };

  darwin.ifEnabled = {...}: {
    programs.bash = {
      enable = true;
      completion.enable = false;
    };
  };

  nixos.ifEnabled = {...}: {
    programs.bash = {
      enable = true;
      completion.enable = false;
    };
  };
}
