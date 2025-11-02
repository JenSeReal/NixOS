{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.brave";
  options = delib.singleEnableOption false;

  darwin.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [brave];
  };

  home.ifEnabled = {...}: {
    programs.chromium.enable = false;
    programs.brave = {
      enable = true;
      extensions = [
        {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";}
        {id = "oldceeleldhonbafppcapldpdifcinji";}
        {id = "jeoacafpbcihiomhlakheieifhpjdfeo";}
        {id = "pkehgijcmpdhfbdbbnkijodmdjhbjlgp";}
        {id = "nngceckbapebfimnlniiiahkandclblb";}
        {id = "lckanjgmijmafbedllaakclkaicjfmnk";}
        {id = "ldpochfccmkkmhdbclfhpagapcfdljkj";}
        {id = "bkdgflcldnnnapblkhphbgpggdiikppg";}
        {id = "mlomiejdfkolichcflejclcbmpeaniij";}
      ];
    };
  };

  nixos.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [brave];
  };
}
