{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.${namespace}.programs.gui.ide.zed;
in {
  options.${namespace}.programs.gui.ide.zed = {
    enable = mkEnableOption "Whether or not to enable zed editor.";
  };

  config = mkIf cfg.enable {
    nixGL.vulkan.enable = true;

    programs.zed-editor = {
      enable = true;
      installRemoteServer = true;
      extraPackages = with pkgs.unstable; [
        alejandra
        direnv
        devenv
        hexyl
        nil
        nixd
        rust-analyzer
        yaml-language-server
      ];

      extensions = [
        "biome"
        "nix"
        "toml"
      ];

      userSettings = {
        auto_update = false;
        telemetry = {
          diagnostics = false;
          metrics = false;
        };

        indent_guides.coloring = "indent_aware";

        inlay_hints = {
          enabled = false;
          show_background = false;

          toggle_on_modifiers_press.alt = true;
        };

        languages = {
          Nix.formatter.external = {
            command = "alejandra";
            arguments = ["--quiet" "--"];
          };
        };

        lsp = {
          nix.binary.path_lookup = true;
          nixd.binary.path_lookup = true;
          nil.binary.path_lookup = true;

          yaml-language-server = {
            settings.yaml = {
              schemaStore.enable = true;
            };
          };
        };
      };
    };
  };
}
