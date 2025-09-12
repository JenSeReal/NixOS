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

      cpuFreqGovernor = enumOption ["performance" "ondemand" "powersave"] "powersave";
    };

  nixos.ifEnabled = {cfg, ...}: {
    powerManagement = {
      enable = true;
      inherit (cfg) cpuFreqGovernor;
    };

    # services.power-profiles-daemon.enable = true;
    # services.auto-cpufreq.enable = true;
    # hardware.system76.power-daemon = enabled;
  };

  nixos.ifDisabled.powerManagement.enable = false;

  darwin.always = {
    power.sleep.computer = 5;
    power.sleep.display = 2;
  };
}
