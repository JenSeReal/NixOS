{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  biomeDefault = {
    formatter = {
      language_server = {
        name = "biome";
      };
    };
    code_actions_on_format = {
      "source.fixAll.biome" = true;
      "source.organizeImports.biome" = true;
    };
  };

  cfg = config.${namespace}.programs.gui.ide.zed;
in
{
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
        opentofu
        tofu-ls
        (runCommand "terraform" { } ''
          mkdir -p "$out"/bin
          ln -s ${lib.getExe opentofu} "$out"/bin/terraform
        '')
        (runCommand "terraform-ls" { } ''
          mkdir -p "$out"/bin
          ln -s ${lib.getExe tofu-ls} "$out"/bin/terraform-ls
        '')
        yaml-language-server
        treefmt
        biome
        yamlfmt
        jsonfmt
        taplo
      ];

      extensions = [
        "biome"
        "env"
        "git-firefly"
        "nix"
        "toml"
        "terraform"
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
        file_scan_exclusions = [
          "**/.git"
          "**/.svn"
          "**/.hg"
          "**/.jj"
          "**/CVS"
          "**/.DS_Store"
          "**/Thumbs.db"
          "**/.classpath"
          "**/.settings"
          "**/terraform.tfstate"
          "**/*.lock.hcl"
        ];
        file_types = {
          "Shell" = [ ".envrc*" ];
        };

        languages = {
          Nix.formatter.external = {
            command = "alejandra";
            arguments = [
              "--quiet"
              "--"
            ];
          };
          YAML = {
            formatter.external = {
              command = "yamlfmt";
              arguments = [ "-in" ];
            };
            prettier = {
              allowed = false;
            };
          };
          TOML.formatter.external.command = "taplo";

          JavaScript = { } // biomeDefault;
          TypeScript = { } // biomeDefault;

          JSX = { } // biomeDefault;
          TSX = { } // biomeDefault;

          JSON = { } // biomeDefault;

          JSONC = { } // biomeDefault;
        };

        lsp = {
          biome.settings = { };

          yaml-language-server.settings.yaml.schemaStore.enable = true;
        };
      };
    };
  };
}
