{
  delib,
  lib,
  pkgs,
  ...
}: let
  defaultIconFileName = "icon.png";
  defaultIcon = pkgs.stdenvNoCC.mkDerivation {
    name = "default-icon";
    src = ./. + "/${defaultIconFileName}";

    dontUnpack = true;

    installPhase = ''
      cp $src $out
    '';

    passthru = {
      fileName = defaultIconFileName;
    };
  };
in
  delib.module {
    name = "user";

    options = with delib;
      moduleOptions {
        uid = intOption 501;
        name = strOption myconfig.constants.username;
        fullName = strOption myconfig.constants.fullName;
        email = strOption myconfig.constants.email;
        initialPassword = strOption "password";
        icon = allowNull (packageOption null) defaultIcon;
        extraGroups = attrsOfOption str {};
        extraOptions = attrsOfOption str {};
      };

    nixos.always = {cfg, ...}: let
      propagatedIcon =
        pkgs.runCommandNoCC "propagated-icon"
        {
          passthru = {
            inherit (cfg.icon) fileName;
          };
        }
        ''
          local target="$out/share/icons/user/${cfg.name}"
          mkdir -p "$target"

          cp ${cfg.icon} "$target/${cfg.icon.fileName}"
        '';
    in
      {
        myconfig,
        cfg,
        ...
      }: let
        inherit (myconfig.constants) username;
      in {
        environment.systemPackages = [propagatedIcon];

        myconfig.home = {
          file = {
            ".face".source = cfg.icon;
            ".face.icon".source = cfg.icon;
            "Desktop/.keep".text = "";
            "Documents/.keep".text = "";
            "Downloads/.keep".text = "";
            "Music/.keep".text = "";
            "Pictures/.keep".text = "";
            "Videos/.keep".text = "";
            "Pictures/${cfg.icon.fileName or (builtins.baseNameOf cfg.icon)}".source = cfg.icon;
          };

          configFile = {
            "sddm/faces/.${cfg.name}".source = cfg.icon;
          };
        };

        users.users.${username} =
          {
            inherit (cfg) name initialPassword;
            isNormalUser = true;
            shell = pkgs.nushell;
            uid = 1000;
            group = "users";
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

    home.always = {cfg, ...}: {
      assertions = [
        {
          assertion = cfg.name != null;
          message = "user.name must be set";
        }
        {
          assertion = cfg.home != null;
          message = "user.home must be set";
        }
      ];

      home = {
        username = lib.mkDefault cfg.name;
        homeDirectory = lib.mkDefault cfg.home;
      };
    };

    darwin.always = {
      myconfig,
      cfg,
      ...
    }: let
      inherit (myconfig.constants) username;
    in {
      users.users.${username} = {
        inherit (cfg) name;

        uid = lib.mkIf (cfg.uid != null) cfg.uid;
        shell = pkgs.zsh;
        home = "/Users/${username}";
      };
    };
  }
