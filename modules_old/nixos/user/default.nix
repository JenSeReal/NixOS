{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:

let
  inherit (lib) types;
  inherit (lib.${namespace}) mkOpt;
  inherit (types)
    str
    nullOr
    package
    listOf
    attrs
    ;

  cfg = config.${namespace}.user;

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
  defaultIconFileName = "icon.png";

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
  options.${namespace}.user = {
    name = mkOpt str "jfp" "The name to use for the user account.";
    fullName = mkOpt str "Jens Plüddemann" "The full name of the user.";
    email = mkOpt str "jens@plueddemann.de" "The email of the user.";
    initialPassword =
      mkOpt str "password"
        "The initial password to use when the user is first created.";
    icon = mkOpt (nullOr package) defaultIcon "The profile picture to use for the user.";
    extraGroups = mkOpt (listOf str) [ ] "Groups for the user to be assigned.";
    extraOptions = mkOpt attrs { } "Extra options passed to <option>users.users.<name></option>.";
  };

  config = {
    environment.systemPackages = [ propagatedIcon ];

    JenSeReal.home = {
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

    users.users.${cfg.name} = {
      inherit (cfg) name initialPassword;

      extraGroups = [ "wheel" ] ++ cfg.extraGroups;
      group = "users";
      home = "/home/${cfg.name}";
      isNormalUser = true;
    } // cfg.extraOptions;
  };
}
