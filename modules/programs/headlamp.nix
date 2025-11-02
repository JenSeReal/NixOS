{delib, ...}:
delib.module {
  name = "programs.headlamp";
  options = delib.singleEnableOption false;

  darwin.ifEnabled = {...}: {
    myconfig.programs.homebrew = {
      enable = true;
      additionalCasks = ["headlamp"];
    };
  };
}
