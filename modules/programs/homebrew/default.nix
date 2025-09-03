{
  delib,
  lib,
  inputs,
  ...
}:
delib.module {
  name = "programs.homebrew";

  options = with delib;
    moduleOptions {
      enable = boolOption false;
      additionalTaps = listOfOption str [];
      additionalBrews = listOfOption str [];
      additionalCasks = listOfOption (
        coercedTo str
        (name: {
          inherit name;
          args = {};
        })
        (submodule {
          options = {
            name = strOption "";
            args = (submoduleOption {
              options = {no_quarantine = boolOption false;};
            }) {};
          };
        })
      ) [];
      additionalMasApps = attrsOfOption lib.types.ints.positive {};
    };

  darwin.ifEnabled = {
    myconfig,
    cfg,
    ...
  }: let

    # Normalize casks to ensure they're all attribute sets
    normalizedCasks =
      map (
        cask:
          if builtins.isString cask
          then {
            name = cask;
            args = {};
          }
          else cask
      )
      cfg.additionalCasks;
  in {
    nix-homebrew = {
      enable = true;
      user = myconfig.constants.username;
    };

    homebrew = {
      enable = true;
      onActivation = {
        autoUpdate = true;
        upgrade = true;
        cleanup = "zap";
      };
      brews = cfg.additionalBrews;
      casks =
        map (
          cask:
            if cask.args == {}
            then cask.name
            else cask
        )
        normalizedCasks;
      masApps = cfg.additionalMasApps;
      taps = cfg.additionalTaps;
    };
  };
}
