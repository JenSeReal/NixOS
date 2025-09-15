{delib, ...}:
delib.module {
  name = "localization";

  options = with delib;
    moduleOptions {
      enable = boolOption false;
      timeZone = strOption "Europe/Berlin";

      defaultLocale = strOption "en_US.UTF-8";
      extraLocale = strOption "de_DE.UTF-8";
      installAllLocales = boolOption true;
    };

  nixos.ifEnabled = {cfg, ...}: {
    time.timeZone = cfg.timeZone;
    environment.variables.TZ = cfg.timeZone;

    i18n = {
      defaultLocale = cfg.defaultLocale;
      extraLocaleSettings = {
        LC_ADDRESS = cfg.extraLocale;
        LC_COLLATE = cfg.extraLocale;
        LC_IDENTIFICATION = cfg.extraLocale;
        LC_MEASUREMENT = cfg.extraLocale;
        LC_NAME = cfg.extraLocale;
        LC_NUMERIC = cfg.extraLocale;
        LC_MONETARY = cfg.extraLocale;
        LC_PAPER = cfg.extraLocale;
        LC_TELEPHONE = cfg.extraLocale;
        LC_TIME = cfg.extraLocale;
      };

      supportedLocales =
        if cfg.installAllLocales
        then ["all"]
        else [
          "${cfg.locale}/UTF-8"
          "${cfg.extraLocale}/UTF-8"
        ];
    };
  };
}
