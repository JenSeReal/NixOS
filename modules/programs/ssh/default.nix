{delib, ...}:
delib.module {
  name = "programs.ssh";
  options = delib.singleEnableOption false;

  home.ifEnabled = {...}: {programs.ssh.enable = true;};
  nixos.ifEnabled = {...}: {programs.ssh.enable = true;};
}
