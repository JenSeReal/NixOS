{ config, lib, ... }:
with lib;
with lib.JenSeReal;
let
  cfg = config.JenSeReal.programs.gui.browser.brave;
in
{
  options.JenSeReal.programs.gui.browser.brave = with types; {
    enable = mkEnableOption "Whether or not to enable Brave.";
  };

  config = mkIf cfg.enable {
    programs.chromium.enable = false;
    programs.brave = {
      enable = true;
      extensions = [
        { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; }
        { id = "oldceeleldhonbafppcapldpdifcinji"; }
        { id = "jeoacafpbcihiomhlakheieifhpjdfeo"; }
        { id = "pkehgijcmpdhfbdbbnkijodmdjhbjlgp"; }
        { id = "nngceckbapebfimnlniiiahkandclblb"; }
        { id = "lckanjgmijmafbedllaakclkaicjfmnk"; }
        { id = "ldpochfccmkkmhdbclfhpagapcfdljkj"; }
        { id = "bkdgflcldnnnapblkhphbgpggdiikppg"; }
        { id = "mlomiejdfkolichcflejclcbmpeaniij"; }
      ];
    };
  };
}
