{
  delib,
  pkgs,
  lib,
  ...
}:
delib.module {
  name = "programs.codium";

  home.ifEnabled = {...}: {
    programs.vscode.profiles.default = {
      userSettings = {
        "[html][css][scss][less]" = {
          "editor.defaultFormatter" = "vscode.css-language-features";
        };

        "[javascript][javascriptreact][typescript][typescriptreact]" = {
          "editor.defaultFormatter" = "biomejs.biome";
          "editor.tabSize" = 2;
          "editor.insertSpaces" = true;
          "editor.formatOnSave" = true;
          "editor.formatOnPaste" = true;
        };

        "[java][gradle][kotlin][gradle-kotlin-dsl]" = {
          "editor.defaultFormatter" = "richardwillis.vscode-spotless-gradle";
          "spotlessGradle.diagnostics.enable" = true;
          "spotlessGradle.format.enable" = true;
          "editor.codeActionsOnSave" = {
            "source.fixAll.spotlessGradle" = "always";
          };
        };

        "[nix][toml][rust][adoc][markdown]" = {
          "editor.tabSize" = 2;
          "editor.insertSpaces" = true;
          "editor.formatOnSave" = true;
          "editor.formatOnPaste" = true;
        };

        "[github-actions-workflow][yaml]" = {
          "editor.tabSize" = 2;
          "editor.insertSpaces" = true;
          "editor.formatOnSave" = true;
          "editor.formatOnPaste" = true;
          "editor.defaultFormatter" = "kennylong.kubernetes-yaml-formatter";
        };

        "[json]" = {
          "editor.defaultFormatter" = "biomejs.biome";
          "editor.tabSize" = 2;
          "editor.insertSpaces" = true;
          "editor.formatOnSave" = true;
          "editor.formatOnPaste" = true;
        };

        "[typst]" = {
          "editor.formatOnPaste" = true;
          "editor.formatOnSave" = true;
          "editor.insertSpaces" = true;
          "editor.tabSize" = 2;
          "editor.autoClosingBrackets" = "always";
          "editor.autoClosingQuotes" = "always";
        };

        "biome.lsp.bin" = lib.getExe pkgs.biome;

        "codeium.enableConfig" = {
          "*" = true;
          "nix" = true;
        };
        "css.format.enable" = true;
        "css.format.newlineBetweenRules" = true;
        "css.format.newlineBetweenSelectors" = true;
        "css.format.spaceAroundSelectorSeparator" = true;

        "direnv.restart.automatic" = true;

        "editor.bracketPairColorization.enabled" = true;
        # "editor.fontFamily" =
        #   lib.mkDefault "'FiraCode Nerd Font', 'Droid Sans Mono', 'monospace', 'Droid Sans Fallback'";
        # "editor.fontLigatures" = true;
        # "editor.fontSize" = 16;
        # "editor.fontVariations" = "'wght' 350";
        # "editor.fontFamily" = "'Monaspace Neon', monospace";
        # "editor.fontLigatures" = "'calt', 'liga', 'dlig'";
        # "editor.fontLigatures" = "'ss01', 'ss02', 'ss03', 'ss04', 'ss05', 'ss06', 'ss07', 'ss08', 'calt', 'dlig'",
        "editor.tokenColorCustomizations" = {
          "textMateRules" = [
            {
              "scope" = "comment";
              "settings" = {"fontStyle" = "italic";};
            }
            {
              "scope" = "storage,entity,variable";
              "settings" = {"fontStyle" = "";};
            }
          ];
        };

        "editor.inlayHints.enabled" = "on";
        "editor.linkedEditing" = true;
        "editor.codeActionsOnSave" = {
          "source.addMissingImports" = "always";
          "source.organizeImports" = "always";
          "source.sortImports" = "always";
          "source.fixAll" = "always";
          "quickfix.biome" = "always";
          "source.organizeImports.biome" = "always";
        };

        "explorer.confirmDelete" = false;
        "explorer.confirmDragAndDrop" = false;

        "files.trimTrailingWhitespace" = true;
        "files.exclude" = {
          "**/.git" = true;
          "**/.svn" = true;
          "**/.hg" = true;
          "**/CVS" = true;
          "**/.DS_Store" = true;
          "**/Thumbs.db" = true;
          "**/.direnv/" = true;
          "**/.devenv/" = true;
          "**/.devenv*" = true;
          "**/flake.lock" = true;
          "**/.envrc" = true;
          "**/LICENSE" = true;
          # "**/README.md" = true;
          "**/.terraform*" = true;
          "**/*.tfstate*" = true;
          "**/node_modules/" = true;
        };

        "html.autoClosingTags" = true;
        "indentRainbow.colors" = [
          "rgba(255,255,64,0.3)"
          "rgba(127,255,127,0.3)"
          "rgba(255,127,255,0.3)"
          "rgba(79,236,236,0.3)"
        ];
        "indentRainbow.indicatorStyle" = "light";
        "indentRainbow.lightIndicatorStyleLineWidth" = 1;
        "javascript.autoClosingTags" = true;
        "javascript.preferences.renameMatchingJsxTags" = true;
        "javascript.suggest.autoImports" = true;
        "javascript.updateImportsOnFileMove.enabled" = "always";
        "keyboard.dispatch" = "keyCode";

        "nix.enableLanguageServer" = true;
        "nix.serverPath" = lib.getExe pkgs.nixd;
        "nix.serverSettings"."nixd"."formatting"."command" = [
          "${lib.getExe pkgs.alejandra}"
        ];

        "remote.SSH.useLocalServer" = false;

        "redhat.telemetry.enabled" = false;

        "search.followSymlinks" = false;

        "telemetry.telemetryLevel" = "off";

        # "terminal.integrated.fontFamily" = mkDefault "'FiraCode Nerd Font', 'monospace'";
        "terminal.integrated.cursorStyle" = lib.mkDefault "line";
        # "terminal.integrated.defaultProfile.osx" =
        #   libmkIf config.JenSeReal.programs.shells.nushell.enable "nu";
        # "terminal.integrated.fontFamily" = "Monaspace Neon Var, Fira Code, Monaco, monospace";
        # "terminal.integrated.fontSize" = 14;
        # "terminal.integrated.fontWeight" = 500;
        # "terminal.integrated.fontWeightBold" = 800;

        "vsicons.dontShowNewVersionMessage" = true;

        "window.commandCenter" = false;
        "window.menuBarVisibility" = lib.mkIf (!pkgs.stdenv.isDarwin) "toggle";
        "window.titleBarStyle" = "native";
        "workbench.colorTheme" = lib.mkDefault "SynthWave '84";
        "workbench.iconTheme" = "vscode-icons";
        "workbench.layoutControl.enabled" = false;
        "workbench.sideBar.location" = "right";
        "workbench.startupEditor" = "none";
        "workbench.tree.indent" = 16;

        "yaml.format.enable" = false;

        "update.mode" = "none";
      };
    };
  };
}
