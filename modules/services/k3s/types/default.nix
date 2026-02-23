{lib, ...}: let
  encryptedManifestType = lib.types.submodule {
    options = {
      sopsFile = lib.mkOption {
        type = lib.types.path;
        description = "Path to sops-encrypted Kubernetes manifest file";
      };
      format = lib.mkOption {
        type = lib.types.enum ["yaml" "binary"];
        default = "yaml";
        description = "Format of the sops file";
      };
    };
  };

  plainManifestType = lib.types.submodule {
    options = {
      file = lib.mkOption {
        type = lib.types.path;
        description = "Path to plain Kubernetes manifest file";
      };
    };
  };
in {
  inherit encryptedManifestType plainManifestType;

  secretsOption = lib.mkOption {
    type = lib.types.attrsOf encryptedManifestType;
    default = {};
    description = "Sops-encrypted Kubernetes Secret manifests to deploy";
    example = lib.literalExpression ''
      {
        flux-git-auth = {
          sopsFile = ./secrets/flux-git-auth.yaml;
        };
      }
    '';
  };

  repositoriesOption = lib.mkOption {
    type = lib.types.attrsOf plainManifestType;
    default = {};
    description = "Plain Kubernetes manifests for Flux GitRepository resources";
    example = lib.literalExpression ''
      {
        nixos = {
          file = ./manifests/nixos-repo.yaml;
        };
      }
    '';
  };
}
