{
  description = "Modular configuration of NixOS, Home Manager, and Nix-Darwin with Denix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs";

    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-25.05-darwin";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    denix = {
      url = "github:yunfachi/denix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
      inputs.nix-darwin.follows = "nix-darwin";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    ucodenix.url = "github:e-tho/ucodenix";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mac-app-util = {
      url = "github:hraban/mac-app-util";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = {
    denix,
    nixpkgs,
    ...
  } @ inputs: let
    lib = nixpkgs.lib;

    packageNixFiles = lib.pipe ./packages [
      builtins.readDir
      (lib.filterAttrs (
        name: type:
          type
          == "directory"
          && builtins.pathExists (./packages + "/${name}/package.nix")
      ))
      (lib.mapAttrsToList (name: _: ./packages + "/${name}/package.nix"))
    ];
    moduleSubdirs = let
      findModuleDirs = dir:
        lib.concatMap (
          name: let
            path = dir + "/${name}";
            type = builtins.readFileType path;
          in
            if type == "directory"
            then
              (
                if name == "modules" || name == "types"
                then [path]
                else []
              )
              ++ findModuleDirs path
            else []
        ) (builtins.attrNames (builtins.readDir dir));
    in
      findModuleDirs ./modules;
    mkConfigurations = moduleSystem:
      denix.lib.configurations {
        inherit moduleSystem;
        homeManagerUser = "jfp";

        paths = [
          ./hosts
          ./modules
          ./rices
          ./overlays
          ./packages
        ];

        exclude = packageNixFiles ++ moduleSubdirs;

        extensions = import ./extensions {delib = denix.lib;};

        specialArgs = {
          inherit inputs moduleSystem;
        };
      };
  in {
    nixosConfigurations = mkConfigurations "nixos";
    homeConfigurations = mkConfigurations "home";
    darwinConfigurations = mkConfigurations "darwin";
  };
}
