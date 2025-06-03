{
  config,
  pkgs,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.types) int;
  inherit (lib.${namespace}) mkBoolOpt mkOpt enabled;

  cfg = config.${namespace}.system;
in {
  options.${namespace}.system = {
    enable = mkBoolOpt true "Wether to enable custom system stuff.";
    stateVersion = mkOpt int 5 "The version of the state to use.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      direnv
      nix-direnv
      jq
    ];

    ${namespace}.system = {
      input = {
        fingerprint = enabled;
        keyboard = enabled;
        mouse = enabled;
        touchpad = enabled;
      };

      power = enabled;

      shells = {
        bash = enabled;
        fish = enabled;
        nu = enabled;
        zsh = enabled;
      };
    };

    system = {
      defaults.smb.NetBIOSName = config.networking.hostName;
    };

    system.stateVersion = cfg.stateVersion;
  };
}
