{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.JenSeReal.programs.tui.nvim;
in
{
  options.JenSeReal.programs.tui.nvim = {
    enable = mkEnableOption "Whether or not to enable neovim.";
  };

  config = mkIf cfg.enable { programs.neovim.enable = true; };
}
