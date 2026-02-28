{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "services.kanshi";
  options = delib.singleEnableOption false;

  home.ifEnabled = {...}: let
    tv = {
      status = "enable";
      criteria = "Samsung Electric Company SAMSUNG 0x01000E00";
      mode = "2560x1440@59.951000Hz";
      scale = 1.6;
    };

    msi = {
      status = "enable";
      criteria = "Microstep MSI MAG271C 0x0000011E";
      mode = "1920x1080@143.85Hz";
      scale = 1.0;
    };

    lg = {
      status = "enable";
      criteria = "LG Electronics LG ULTRAWIDE 0x00017279";
      mode = "2560x1080@144Hz";
      scale = 1.0;
    };

    laptop = {
      status = "enable";
      criteria = "eDP-1";
      scale = 1.333333;
    };
  in {
    services.kanshi = {
      enable = true;

      settings = [
        # Desktop (el-macchina) profiles
        {
          profile = {
            name = "desktop-single";
            outputs = [
              (
                lg
                // {
                  position = "0,0";
                }
              )
            ];
          };
        }

        {
          profile = {
            name = "desktop-double";
            outputs = [
              (msi // {position = "${toString ((2560 - 1920) / 2)},0";})
              (lg // {position = "0,1080";})
            ];
          };
        }

        # Laptop profiles
        {
          profile = {
            name = "undocked";
            outputs = [laptop];
          };
        }

        {
          profile.name = "home-double";
          profile.outputs = [
            (laptop // {status = "disable";})
            (lg // {position = "${toString (builtins.floor (2256 / laptop.scale))},1080";})
            (
              msi // {position = "${toString ((builtins.floor (2256 / laptop.scale)) + ((2560 - 1920) / 2))},0";}
            )
          ];
        }

        {
          profile.name = "home-single";
          profile.outputs = [
            (laptop // {status = "disable";})
            (lg // {position = "${toString (builtins.floor (1920 / laptop.scale))},0";})
          ];
        }

        {
          profile.name = "home-tv";
          profile.outputs = [
            (laptop // {position = "0,960";})
            (tv // {position = "106,0";})
          ];
        }
      ];
    };
  };

  nixos.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [
      kanshi
    ];
    # myconfig.user.extraGroups = ["input"];
  };
}
