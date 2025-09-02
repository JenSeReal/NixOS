{
  lib,
  config,
  namespace,
  ...
}:

let
  inherit (lib) mkIf types mkEnableOption;
  inherit (lib.${namespace}) mkOpt;
  inherit (types) str;
  cfg = config.JenSeReal.system.locale;
in
{
  options.JenSeReal.system.locale = {
    enable = mkEnableOption "Whether or not to use the variables set.";
    defaultLocale = mkOpt str "en_US.UTF-8" "The language to use";
    extraLocale = mkOpt str "de_DE.UTF-8" "The locale to use";
  };

  config = mkIf cfg.enable {
    i18n.extraLocaleSettings = {
      defaultLocale = cfg.defaultLocale;
      LC_ADDRESS = cfg.extraLocale;
      LC_IDENTIFICATION = cfg.extraLocale;
      LC_MEASUREMENT = cfg.extraLocale;
      LC_MONETARY = cfg.extraLocale;
      LC_NAME = cfg.extraLocale;
      LC_NUMERIC = cfg.extraLocale;
      LC_PAPER = cfg.extraLocale;
      LC_TELEPHONE = cfg.extraLocale;
      LC_TIME = cfg.extraLocale;
    };
  };
}
