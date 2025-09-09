{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.neovim";
  options = delib.singleEnableOption false;

  darwin.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [neovim];
  };

  home.ifEnabled = {...}: {
    programs.neovim.enable = true;
  };

  nixos.ifEnabled = {...}: {
    programs.neovim.enable = true;
  };
}
