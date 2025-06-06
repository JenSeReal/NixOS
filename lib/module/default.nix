{ lib, ... }:

let
  inherit (lib) mkOption types;
in

rec {
  ## Create a NixOS module option.
  ##
  ## ```nix
  ## lib.mkOpt nixpkgs.lib.types.str "My default" "Description of my option."
  ## ```
  ##
  #@ Type -> Any -> String
  mkOpt =
    type: default: description:
    mkOption { inherit type default description; };

  ## Create a NixOS module option without a description.
  ##
  ## ```nix
  ## lib.mkOpt' nixpkgs.lib.types.str "My default"
  ## ```
  ##
  #@ Type -> Any -> String
  mkOpt' = type: default: mkOpt type default null;

  ## Create a boolean NixOS module option.
  ##
  ## ```nix
  ## lib.mkBoolOpt true "Description of my option."
  ## ```
  ##
  #@ Type -> Any -> String
  mkBoolOpt = mkOpt types.bool;

  ## Create a boolean NixOS module option without a description.
  ##
  ## ```nix
  ## lib.mkBoolOpt true
  ## ```
  ##
  #@ Type -> Any -> String
  mkBoolOpt' = mkOpt' types.bool;

  ## Create a string NixOS module option.
  ##
  ## ```nix
  ## lib.mkStrOpt true "Description of my option."
  ## ```
  ##
  #@ Type -> Any -> String
  mkStrOpt = mkOpt types.str;

  ## Create a string NixOS module option without a description.
  ##
  ## ```nix
  ## lib.mkStrOpt true
  ## ```
  ##
  #@ Type -> Any -> String
  mkStrOpt' = mkOpt' types.str;

  ## Create a package NixOS module option.
  ##
  ## ```nix
  ## lib.mkPackageOpt true "Description of my option."
  ## ```
  ##
  #@ Type -> Any -> package
  mkPackageOpt = mkOpt types.package;

  ## Create a package NixOS module option without a description.
  ##
  ## ```nix
  ## lib.mkStrOpt true
  ## ```
  ##
  #@ Type -> Any -> package
  mkPackageOpt' = mkOpt' types.package;

  enabled = {
    ## Quickly enable an option.
    ##
    ## ```nix
    ## services.nginx = enabled;
    ## ```
    ##
    #@ true
    enable = true;
  };

  disabled = {
    ## Quickly disable an option.
    ##
    ## ```nix
    ## services.nginx = enabled;
    ## ```
    ##
    #@ false
    enable = false;
  };

  mkNullOrBoolOption =
    args:
    mkOption (
      args
      // {
        type = types.nullOr types.bool;
        default = null;
      }
    );
}
