{delib, ...}:
delib.module {
  name = "programs.nix-ld";
  options = delib.singleEnableOption false;

  nixos.ifEnabled = {...}: {
    programs.nix-ld.enable = true;
    programs.nix-ld.libraries = [];
  };
}
