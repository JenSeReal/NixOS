{delib, ...}:
delib.module {
  name = "power-management";
  options = delib.singleEnableOption false;

  nixos.ifEnabled = {...}: {
    # https://github.com/nickhartjes/nixos-config/blob/main/hosts/framework-13/configuration.nix
    powerManagement = {
      enable = true;
      powertop.enable = true;
    };

    services.power-profiles-daemon.enable = true;
  };

  nixos.ifDisabled.powerManagement.enable = false;

  darwin.always = {
    power.sleep.computer = 5;
    power.sleep.display = 2;
  };
}
