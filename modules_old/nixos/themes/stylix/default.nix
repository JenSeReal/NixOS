{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.themes.stylix;
in {
  options.${namespace}.themes.stylix = {};

  imports = [(lib.snowfall.fs.get-file "modules/common/themes/stylix/default.nix")];

  config = mkIf cfg.enable {};
}
