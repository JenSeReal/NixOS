{
  delib,
  host,
  ...
}:
delib.module {
  name = "settings.power-management";

  options = with delib;
    moduleOptions {
      enable = boolOption true;

      cpuFreqGovernor = enumOption ["performance" "ondemand" "powersave"] (
        if host.powersaveFeatured
        then "powersave"
        else "performance"
      );
    };

  nixos.ifEnabled = {cfg, ...}: {
    powerManagement = {
      enable = true;
      inherit (cfg) cpuFreqGovernor;
    };
  };

  nixos.ifDisabled.powerManagement.enable = false;

  darwin.always = {
    power.sleep.computer = 5;
    power.sleep.display = 2;
  };
}
