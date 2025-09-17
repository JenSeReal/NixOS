{
  delib,
  inputs,
  ...
}:
delib.rice {
  name = "synthwave84";

  nixos = {
    imports = [inputs.stylix.nixosModules.stylix];

    stylix = {
      enable = true;
      base16Scheme = ./base16Scheme.yaml;
      image = ./P13_Background1.png;
      polarity = "dark";
      homeManagerIntegration.autoImport = false;
      # homeManagerIntegration.followSystem = false;
    };
  };

  home = {
    imports = [inputs.stylix.homeModules.stylix];

    stylix = {
      enable = true;
      polarity = "dark";
      image = ./P13_Background1.png;
      base16Scheme = ./base16Scheme.yaml;
    };
  };
}
