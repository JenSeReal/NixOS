{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.nemo";
  options = delib.singleEnableOption false;

  nixos.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [nemo-with-extensions nemo-preview nemo-fileroller];
    services.gvfs.enable = true;
  };
}
