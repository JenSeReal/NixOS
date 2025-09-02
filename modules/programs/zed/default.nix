{delib, ...}:
delib.module {
  name = "programs.zed";
  options = delib.singleEnableOption false;

  home.ifEnabled = {...}: {
    programs.zed-editor = {
      enable = true;
      installRemoteServer = true;
    };
  };
}
