{
  config,
  lib,
  namespace,
  options,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.theming.stylix;
in {
  options.${namespace}.theming.stylix = {
    enable = mkEnableOption "Whether or not to enable stylix theming.";
  };

  config = mkIf cfg.enable (
    lib.optionalAttrs (options ? stylix) {
      stylix = {
        enable = true;
        image = ./2.jpg;
        base16Scheme = ./synthwave84.yaml;
      };
    }
  );
}
