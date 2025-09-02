{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.system.shells.bash;
in
{
  options.${namespace}.system.shells.bash = {
    enable = mkBoolOpt true "Wether to enable bash shell.";
  };

  config = mkIf cfg.enable {
    programs.bash.enable = true;
    programs.bash.completion.enable = false;
  };
}
