{
  delib,
  pkgs,
  inputs,
  ...
}:
delib.module {
  name = "programs.codium";
  options = delib.singleEnableOption false;

  home.ifEnabled = {...}: {
    imports = [inputs.vscode-server.homeModules.default];

    services.vscode-server.enable = true;
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
    };
  };
}
