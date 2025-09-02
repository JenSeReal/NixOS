{delib, ...}:
delib.module {
  name = "programs.citrix-workspace";
  options = delib.singleEnableOption false;

  darwin.ifEnabled = {...}: {
    myconfig.programs.homebrew = {
      enable = true;
      additionalCasks = ["citrix-workspace"];
    };
  };
}
