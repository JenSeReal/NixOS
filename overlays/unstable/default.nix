{ channels, ... }:
final: prev: {
  inherit (channels.nixpkgs-unstable)
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
}
