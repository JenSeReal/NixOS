{delib, ...}: let
  common.nixpkgs = {
    config = {
      allowUnfree = true;
      doCheckByDefault = false;
      # Or more specifically:
      packageOverrides = pkgs: {
        rsync = pkgs.rsync.overrideAttrs {doCheck = false;};
        sbcl = pkgs.sbcl.overrideAttrs {doCheck = false;};
      };
    };
  };
  files."nixpkgs/config.nix".text = ''
    {
      allowUnfree = true;
    }
  '';
  variables."NIXPKGS_ALLOW_UNFREE" = 1;
in
  delib.module {
    name = "settings.nixpkgs";

    nixos.always =
      common
      // {
        environment.variables = variables;
      };
    # home.always =
    #   common
    #   // {
    #     xdg.configFile = files;
    #     home.sessionVariables = variables;
    #   };
  }
