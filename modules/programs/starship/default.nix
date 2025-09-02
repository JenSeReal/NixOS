{delib, ...}:
delib.module {
  name = "programs.starship";
  options = delib.singleEnableOption false;

  home.ifEnabled = {...}: {
    programs.starship.enable = true;
  };
}
