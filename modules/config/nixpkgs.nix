{delib, ...}:
delib.module {
  name = "nixpkgs";

  nixos.always = {
    nixpkgs.config.allowUnfree = true;
    environment.variables."NIXPKGS_ALLOW_UNFREE" = 1;
  };
}
