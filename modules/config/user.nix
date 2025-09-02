{
  delib,
  lib,
  pkgs,
  ...
}:
delib.module {
  name = "user";

  options = with delib;
    moduleOptions {
      uid = intOption 501;
      extraGroups = attrsOfOption str {};
      extraOptions = attrsOfOption str {};
    };

  nixos.always = {
    myconfig,
    cfg,
    ...
  }: let
    inherit (myconfig.constants) username;
  in {
    users.users.${username} =
      {
        isNormalUser = true;
        shell = pkgs.nushell;
        uid = 1000;
        home = "/home/${username}";
        extraGroups =
          [
            "wheel"
            "systemd-journal"
            "mpd"
            "audio"
            "video"
            "input"
            "plugdev"
            "lp"
            "tss"
            "power"
            "nix"
          ]
          ++ cfg.extraGroups;
      }
      // cfg.extraOptions;
  };

  darwin.always = {
    myconfig,
    cfg,
    ...
  }: let
    inherit (myconfig.constants) username;
  in {
    users.users.${username} = {
      uid = lib.mkIf (cfg.uid != null) cfg.uid;
      name = username;
      shell = pkgs.zsh;
      home = "/Users/${username}";
    };
  };
}
