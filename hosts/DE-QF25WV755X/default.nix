{
  delib,
  inputs,
  ...
}:
delib.host {
  name = "DE-QF25WV755X";
  rice = "synthwave84";
  type = "laptop";

  myconfig = {
    programs = {
      citrix-workspace.enable = true;
      codium.enable = true;
      direnv.enable = true;
      docker.enable = true;
      fish.enable = true;
      nu.enable = true;
      git.enable = true;
      zed.enable = true;
      zsh.enable = true;
    };
    desktop-environments.aerospace.enable = true;
  };

  darwin = {
    imports = [
      # inputs.determinate.darwinModules.default
      inputs.nix-homebrew.darwinModules.nix-homebrew
    ];

    nixpkgs = {
      hostPlatform = "aarch64-darwin";
      config.allowUnfree = true;
    };

    system = {
      stateVersion = 5;
      primaryUser = "jfp";
    };
  };
}
