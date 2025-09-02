{
  config,
  lib,
  namespace,
  options,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.themes.stylix;
in {
  options.${namespace}.themes.stylix = {
    enable = mkEnableOption "Whether or not to enable stylix theming.";
  };

  config = mkIf cfg.enable (
    lib.optionalAttrs (options ? stylix) {
      stylix = {
        enable = true;
        image = ./P13_Background1.png;
        base16Scheme = ./synthwave84.yaml;
      };
    }
  );
}
