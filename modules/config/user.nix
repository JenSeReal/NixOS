{
  delib,
  pkgs,
  lib,
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
        uid = intOption (
          if pkgs.stdenv.isDarwin
          then 501
          else 1000
        );
        name = strOption "jfp";
        fullName = strOption "Jens Plüddemann";
        email = strOption "jens@plueddemann.de";
        initialPassword = strOption "password";
        icon = allowNull (packageOption defaultIcon);

        extraGroups = listOfOption str [];
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
    in {
      environment.systemPackages = [propagatedIcon];

      myconfig.home = {
        file = {
          ".face".source = cfg.icon;
          ".face.icon".source = cfg.icon;
          "Desktop/.keep".text = "";
          "Documents/.keep".text = "";
          "Downloads/.keep".text = "";
          "Pictures/.keep".text = "";
          "Videos/.keep".text = "";
          "Pictures/${cfg.icon.fileName or (builtins.baseNameOf cfg.icon)}".source = cfg.icon;
        };

        configFile = {
          "sddm/faces/.${cfg.name}".source = cfg.icon;
        };
      };

      users = {
        groups.${cfg.name} = {};

        users.${cfg.name} =
          {
            inherit (cfg) initialPassword;
            uid = 1000;

            shell = pkgs.nushell;
            group = "users";
            home = "/home/${cfg.name}";

            isNormalUser = true;
            extraGroups = ["wheel"] ++ cfg.extraGroups;
          }
          // cfg.extraOptions;
      };
    };

    darwin.always = {cfg, ...}: let
      inherit (cfg) name;
    in {
      users.users.${name} = {
        uid = lib.mkIf (cfg.uid != null) cfg.uid;
        shell = pkgs.zsh;
        home = "/Users/${name}";
      };
    };

    home.always = {cfg, ...}: {
      assertions = [
        {
          assertion = cfg.name != null;
          message = "user.name must be set";
        }
      ];

      home = {
        username = lib.mkDefault cfg.name;
        homeDirectory = lib.mkDefault (
          if pkgs.stdenv.isDarwin
          then "/Users/${cfg.name}"
          else "/home/${cfg.name}"
        );
      };
    };
  }
