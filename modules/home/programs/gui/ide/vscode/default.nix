{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption mkDefault;
  cfg = config.JenSeReal.programs.gui.ide.vscode;

  pkgs-ext = import inputs.nixpkgs {
    inherit (pkgs) system;
    config.allowUnfree = true;
    overlays = [ inputs.nix-vscode-extensions.overlays.default ];
  };
  marketplace = pkgs-ext.vscode-marketplace;

  is-darwin = pkgs.stdenv.isDarwin;

  vscodePname = config.programs.vscode.package.pname;

  configDir =
    {
      "vscode" = "Code";
      "vscode-insiders" = "Code - Insiders";
      "vscodium" = "VSCodium";
    }
    .${vscodePname};

  userDir =
    if is-darwin then
      "Library/Application Support/${configDir}/User"
    else
      "${config.xdg.configHome}/${configDir}/User";

  configFilePath = "${userDir}/settings.json";
  # keybindingsFilePath = "${userDir}/keybindings.json";

  pathsToMakeWritable = lib.flatten [ configFilePath ];
in
{
  options.JenSeReal.programs.gui.ide.vscode = {
    enable = mkEnableOption "Whether or not to enable vs code.";
  };

  imports = [
    ./mutable.nix
    inputs.vscode-server.homeModules.default
  ];

  config = mkIf cfg.enable {
    services.vscode-server.enable = true;
    programs.vscode = {

      enable = true;

      # profiles.default = {
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
            "source.fixAll.spotlessGradle" = true;
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

        "[typst]" = {
          "editor.formatOnPaste" = true;
          "editor.formatOnSave" = true;
          "editor.insertSpaces" = true;
          "editor.tabSize" = 2;
          "editor.autoClosingBrackets" = "always";
          "editor.autoClosingQuotes" = "always";
          "editor.defaultFormatter" = "nvarner.typst-lsp";
        };

        "codeium.enableConfig" = {
          "*" = true;
          "nix" = true;
        };

        "css.format.enable" = true;
        "css.format.newlineBetweenRules" = true;
        "css.format.newlineBetweenSelectors" = true;
        "css.format.spaceAroundSelectorSeparator" = true;

        "editor.bracketPairColorization.enabled" = true;
        "editor.fontFamily" =
          lib.mkDefault "'FiraCode Nerd Font', 'Droid Sans Mono', 'monospace', 'Droid Sans Fallback'";
        "editor.fontLigatures" = true;
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
        "nix.formatterPath" = "nixfmt";
        "nix.serverPath" = "nixd";
        "nix.serverSettings" = {
          "nixd" = {
            "formatting" = {
              "command" = [ "nixfmt" ];
            };
          };
        };

        "remote.SSH.useLocalServer" = false;

        "search.followSymlinks" = false;

        "telemetry.telemetryLevel" = "all";
        "terminal.integrated.fontFamily" = mkDefault "'FiraCode Nerd Font', 'monospace'";
        "terminal.integrated.cursorStyle" = mkDefault "line";
        "terminal.integrated.defaultProfile.osx" =
          mkIf config.JenSeReal.programs.shells.nushell.enable "nu";
        "typst-lsp.experimentalFormatterMode" = "on";

        "vsicons.dontShowNewVersionMessage" = true;

        "window.commandCenter" = false;
        "window.menuBarVisibility" = mkIf (!is-darwin) "toggle";
        "window.titleBarStyle" = "native";
        "workbench.colorTheme" = mkDefault "SynthWave '84";
        "workbench.iconTheme" = "vscode-icons";
        "workbench.layoutControl.enabled" = false;
        "workbench.sideBar.location" = "right";
        "workbench.startupEditor" = "none";
        "workbench.tree.indent" = 16;

        "yaml.format.enable" = false;
      };

      extensions = [
        marketplace.yzhang.markdown-all-in-one
        marketplace.asciidoctor.asciidoctor-vscode
        marketplace.tamasfe.even-better-toml
        marketplace.redhat.vscode-yaml
        marketplace.kennylong.kubernetes-yaml-formatter
        marketplace.ms-azuretools.vscode-docker
        marketplace.usernamehw.errorlens
        marketplace.cordx56.rustowl-vscode
        marketplace.shardulm94.trailing-spaces
        marketplace.christian-kohler.path-intellisense
        marketplace.vscode-icons-team.vscode-icons
        marketplace.redhat.vscode-xml
        marketplace.oderwat.indent-rainbow
        marketplace.rust-lang.rust-analyzer
        marketplace.fill-labs.dependi
        marketplace.tauri-apps.tauri-vscode
        marketplace.editorconfig.editorconfig
        # marketplace.vadimcn.vscode-lldb
        marketplace.pflannery.vscode-versionlens
        marketplace.lorenzopirro.rust-flash-snippets
        marketplace.zhangyue.rust-mod-generator
        marketplace.jedeop.crates-completer
        marketplace.jscearcy.rust-doc-viewer
        marketplace.biomejs.biome
        marketplace.rangav.vscode-thunder-client
        marketplace.dotjoshjohnson.xml
        marketplace.jgclark.vscode-todo-highlight
        marketplace.gruntfuggly.todo-tree
        marketplace.chrmarti.regex
        marketplace.aaron-bond.better-comments
        marketplace.ms-vsliveshare.vsliveshare
        marketplace.pinage404.nix-extension-pack
        marketplace.robbowen.synthwave-vscode
        marketplace.ms-vscode-remote.vscode-remote-extensionpack
        marketplace.formulahendry.docker-explorer
        marketplace.redhat.java
        marketplace.vscjava.vscode-java-test
        marketplace.vscjava.vscode-java-debug
        marketplace.vscjava.vscode-maven
        marketplace.vscjava.vscode-java-dependency
        marketplace.vscjava.vscode-spring-initializr
        marketplace.vscjava.vscode-gradle
        marketplace.codeium.codeium
        marketplace.richardwillis.vscode-spotless-gradle
        marketplace.mathiasfrohlich.kotlin
        marketplace.myriad-dreamin.tinymist
        marketplace.hashicorp.terraform
        marketplace.mgtrrz.terraform-completer

      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [ ];

      keybindings = [ ];
    };

    # };

    home.file = lib.genAttrs pathsToMakeWritable (_: {
      force = true;
      mutable = true;
    });
  };
}
