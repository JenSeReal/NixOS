{delib, ...}:
delib.module {
  name = "programs.miro";

  options = delib.singleEnableOption false;

  darwin.ifEnabled = {...}: {
    myconfig.programs.homebrew = {
      enable = true;
      additionalCasks = ["miro"];
    };
    launchd.user.agents.miro = {
      command = "/Applications/Miro.app/Contents/MacOS/Miro";
      serviceConfig = {
        KeepAlive = false;
        RunAtLoad = true;
      };
    };
  };
}
