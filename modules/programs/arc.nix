{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.arc";
  options = delib.singleEnableOption false;

  darwin.ifEnabled = {...}: {
    environment.systemPackages = [pkgs.arc-browser];
  };
}
