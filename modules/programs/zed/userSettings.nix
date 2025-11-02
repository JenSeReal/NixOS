{
  delib,
  pkgs,
  lib,
  ...
}: let
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
in
  delib.module {
    name = "programs.zed";

    home.ifEnabled = {...}: {
      programs.zed-editor.userSettings = {
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
          "**/.direnv"
          "**/.devenv"
          "**/flake.lock"
        ];
        file_types = {
          "Shell" = [".envrc*"];
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
              command = lib.getExe pkgs.yamlfmt;
              arguments = ["-in"];
            };
            prettier = {
              allowed = false;
            };
          };
          TOML.formatter.external.command = "taplo";

          JavaScript = {} // biomeDefault;
          TypeScript = {} // biomeDefault;

          JSX = {} // biomeDefault;
          TSX = {} // biomeDefault;

          JSON = {} // biomeDefault;

          JSONC = {} // biomeDefault;
        };

        lsp = {
          yaml-language-server = {
            settings.yaml.schemaStore.enable = true;
          };
        };
      };
    };
  }
