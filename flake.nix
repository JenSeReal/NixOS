{
  description = "Modular configuration of NixOS, Home Manager, and Nix-Darwin with Denix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-25.11-darwin";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
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
      url = "github:nix-community/lanzaboote/v0.4.3";
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
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf.url = "github:notashelf/nvf";
    stylix = {
      url = "github:danth/stylix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mac-app-util = {
      url = "github:hraban/mac-app-util";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-anywhere = {
      url = "github:nix-community/nixos-anywhere";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    denix,
    nixpkgs,
    deploy-rs,
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

    findModules = dir:
      lib.concatMap (
        name: let
          path = dir + "/${name}";
          type = builtins.readFileType path;
        in
          if type == "directory"
          then findModules path
          else if
            type
            == "regular"
            && lib.hasSuffix
            ".nix"
            name
            && name != "default.nix"
          then [path]
          else []
      ) (builtins.attrNames (builtins.readDir dir));

    # Helper to extract deploy-rs nodes from nixosConfigurations
    extractDeployNodes = configurations:
      lib.foldl' (acc: name: let
        cfg = configurations.${name}.config.myconfig.deploy or null;
      in
        if cfg != null && cfg.enable
        then
          acc
          // {
            ${name} = {
              hostname = cfg.hostname;
              profiles.system = {
                sshUser = cfg.sshUser;
                sshOpts =
                  if cfg.sshPort != 22
                  then ["-p" (toString cfg.sshPort)]
                  else [];
                user = cfg.deployUser;
                path = deploy-rs.lib.${cfg.system}.activate.nixos configurations.${name};
              };
            };
          }
        else acc) {}
      (builtins.attrNames configurations);
  in {
    nixosConfigurations = mkConfigurations "nixos";
    homeConfigurations = mkConfigurations "home";
    darwinConfigurations = mkConfigurations "darwin";

    nixosModules.default = {...}: {
      imports =
        findModules ./modules
        ++ findModules
        ./overlays;
    };

    homeModules.default = {...}: {
      imports = findModules ./modules;
    };

    darwinModules.default = {...}: {
      imports =
        findModules ./modules
        ++ findModules
        ./overlays;
    };

    # deploy-rs configuration
    # Automatically extracts deploy configuration from all hosts with myconfig.deploy.enable = true
    deploy.nodes = extractDeployNodes inputs.self.nixosConfigurations;

    # This is highly advised, and will prevent many possible mistakes
    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks inputs.self.deploy) inputs.deploy-rs.lib;
  };
}
