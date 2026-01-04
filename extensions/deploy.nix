{
  delib,
  lib,
  ...
}: let
  inherit (delib) extension maintainers moduleOptions;
  inherit (lib) types mkOption;
in
  extension {
    name = "deploy";
    description = "Integrated deployment support for Denix hosts";
    maintainers = with maintainers; [JenSeReal];

    config = final: prev: {
      # Default deploy settings
      defaultSshUser = "jfp";
      defaultDeployUser = "root";
    };

    libExtension = config: final: prev: {
      # Clean API: delib.deploy combines host and deploy configuration
      # Usage: delib.deploy { name = "..."; hostname = "..."; rice = "..."; ... }
      deploy = args @ {
        name,
        hostname,
        sshPort ? 22,
        sshUser ? config.defaultSshUser,
        deployUser ? config.defaultDeployUser,
        system ? "x86_64-linux",
        ...
      }: let
        # Extract deploy-specific args
        deployArgs = {
          inherit hostname sshPort sshUser deployUser system;
        };
        # Remove deploy-specific args, pass the rest to delib.host
        hostArgs = builtins.removeAttrs args [
          "hostname"
          "sshPort"
          "sshUser"
          "deployUser"
          "system"
        ];
      in
        prev.host (hostArgs
          // {
            # Automatically configure myconfig.deploy
            myconfig =
              (hostArgs.myconfig or {})
              // {
                deploy =
                  (hostArgs.myconfig.deploy or {})
                  // {
                    enable = true;
                    inherit hostname sshPort sshUser deployUser system;
                  };
              };
          });

      # Helper to create a deploy-rs node configuration from host metadata
      # The deployRsLib parameter must be passed from the flake (inputs.deploy-rs.lib)
      mkDeployNode = deployRsLib: {
        name,
        hostname,
        nixosConfiguration,
        sshUser ? config.defaultSshUser,
        sshPort ? 22,
        deployUser ? config.defaultDeployUser,
        system ? "x86_64-linux",
      }: {
        ${name} = {
          inherit hostname;
          profiles.system = {
            sshUser = sshUser;
            sshOpts =
              if sshPort != 22
              then ["-p" (toString sshPort)]
              else [];
            user = deployUser;
            path = deployRsLib.${system}.activate.nixos nixosConfiguration;
          };
        };
      };

      # Helper to merge multiple deploy nodes
      mkDeployNodes = nodes: builtins.foldl' (acc: node: acc // node) {} nodes;

      # Extract deploy nodes from all nixosConfigurations
      # Usage: deploy.nodes = denix.lib.extractDeployNodes inputs.deploy-rs.lib inputs.self.nixosConfigurations;
      extractDeployNodes = deployRsLib: configurations:
        lib.foldl' (acc: name: let
          cfg = configurations.${name}.config.myconfig.deploy or null;
        in
          if cfg != null && cfg.enable
          then
            acc
            // (final.mkDeployNode deployRsLib {
              inherit name;
              inherit (cfg) hostname sshPort sshUser deployUser system;
              nixosConfiguration = configurations.${name};
            })
          else acc) {}
        (builtins.attrNames configurations);
    };
  }
