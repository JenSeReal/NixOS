{
  delib,
  lib,
  ...
}: let
  inherit (delib) extension maintainers;
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
      # All args except name are optional, allowing configs to be split across files
      deploy = args @ {
        name,
        hostname ? null,
        sshPort ? null,
        sshUser ? null,
        deployUser ? null,
        system ? null,
        ...
      }: let
        # Remove deploy-specific args, pass the rest to delib.host
        hostArgs = builtins.removeAttrs args [
          "hostname"
          "sshPort"
          "sshUser"
          "deployUser"
          "system"
        ];

        # Only include deploy config if at least hostname is provided
        deployConfig = lib.optionalAttrs (hostname != null) {
          deploy = {
            enable = true;
            inherit hostname;
          } // lib.optionalAttrs (sshPort != null) { inherit sshPort; }
            // lib.optionalAttrs (sshUser != null) { inherit sshUser; }
            // lib.optionalAttrs (deployUser != null) { inherit deployUser; }
            // lib.optionalAttrs (system != null) { inherit system; };
        };
      in
        prev.host (hostArgs
          // lib.optionalAttrs (deployConfig != {}) {
            myconfig = (hostArgs.myconfig or {}) // deployConfig;
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
