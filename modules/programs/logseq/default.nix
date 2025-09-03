{delib, ...}:
delib.module {
  name = "programs.logseq";

  options = delib.singleEnableOption false;

  darwin.ifEnabled = {...}: {
    myconfig.programs.homebrew = {
      enable = true;
      additionalCasks = ["logseq"];
    };
    launchd.user.agents.logseq = {
      command = "/Applications/Logseq.app/Contents/MacOS/Logseq";
      serviceConfig = {
        KeepAlive = true;
        RunAtLoad = true;
      };
    };
  };
}
