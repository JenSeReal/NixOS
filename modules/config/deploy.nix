{
  lib,
  delib,
  ...
}:
delib.module {
  name = "deploy";

  options = with delib;
    moduleOptions {
      enable = boolOption false;

      hostname = lib.mkOption {
        type = lib.types.str;
        description = "SSH connection target (IP address or DNS name)";
      };

      sshPort = lib.mkOption {
        type = lib.types.port;
        default = 22;
        description = "SSH port to connect to";
      };

      sshUser = lib.mkOption {
        type = lib.types.str;
        default = "jfp";
        description = "User to SSH as for deployment";
      };

      deployUser = lib.mkOption {
        type = lib.types.str;
        default = "root";
        description = "User to run the activation as (usually root)";
      };

      system = lib.mkOption {
        type = lib.types.str;
        default = "x86_64-linux";
        description = "System architecture";
      };
    };

  # This module just defines options, no actual configuration
  nixos.ifEnabled = {cfg, ...}: {};
  home.ifEnabled = {cfg, ...}: {};
  darwin.ifEnabled = {cfg, ...}: {};
}
