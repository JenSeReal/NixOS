{
  delib,
  pkgs,
  inputs,
  ...
}:
delib.module {
  name = "programs.anyrun";
  options = delib.singleEnableOption false;

  home.ifEnabled = {
    programs.anyrun = {
      enable = true;
      config = {
        plugins = with inputs.anyrun.packages.${pkgs.system}; [
          applications
          dictionary
          rink
          shell
          symbols
          stdin
          translate
          websearch

          inputs.anyrun-nixos-options.packages.${pkgs.system}.default
        ];
        width = {
          fraction = 0.3;
        };
        hideIcons = false;
        ignoreExclusiveZones = false;
        layer = "overlay";
        hidePluginInfo = false;
        closeOnClick = false;
        showResultsImmediately = false;
        maxEntries = null;
      };
    };
  };

  nixos.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [anyrun];
  };
}
