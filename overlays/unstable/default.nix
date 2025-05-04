{ channels, inputs, ... }:
final: prev: {
  inherit (channels.nixpkgs-unstable)
    aerospace
    bottles-unwrapped
    btop
    clipcat
    colima
    devenv
    "jetbrains.idea-community-bin"
    lutris
    protontricks
    vscode
    wezterm
    wine
    wineWowPackages
    winetricks
    ;

  unstable = import inputs.nixpkgs-unstable {
    system = final.system;
    config.allowUnfree = true;
  };
}
