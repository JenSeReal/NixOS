{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.gnupg";
  options = delib.singleEnableOption false;

  nixos.ifEnabled = {...}: {
    programs.gnupg.agent = with pkgs; {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = lib.mkForce pinentry-qt;
    };
  };
}
