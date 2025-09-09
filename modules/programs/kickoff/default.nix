{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.kickoff";
  options = delib.singleEnableOption false;

  nixos.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [kickoff];
  };
}
