{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.raycast";

  options = with delib; singleEnableOption false;

  darwin.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [raycast];

    launchd.user.agents.raycast = {
      command = "/Applications/Nix Apps/Raycast.app/Contents/MacOS/Raycast";
      serviceConfig = {
        KeepAlive = true;
        RunAtLoad = true;
      };
    };
  };
}
