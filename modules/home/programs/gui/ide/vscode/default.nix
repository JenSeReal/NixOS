{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkDefault;
  cfg = config.JenSeReal.programs.gui.ide.vscode;

  pkgs-ext = import inputs.nixpkgs {
    inherit (pkgs) system;
    config.allowUnfree = true;
    overlays = [inputs.nix-vscode-extensions.overlays.default];
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
    .${
      vscodePname
    };

  userDir =
    if is-darwin
    then "Library/Application Support/${configDir}/User"
    else "${config.xdg.configHome}/${configDir}/User";

  configFilePath = "${userDir}/settings.json";
  # keybindingsFilePath = "${userDir}/keybindings.json";

  pathsToMakeWritable = lib.flatten [configFilePath];
in {
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

        "biome.lsp.bin" = lib.getExe pkgs.unstable.biome;

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
        "nix.serverPath" = lib.getExe pkgs.unstable.nixd;
        "nix.serverSettings"."nixd"."formatting"."command" = [
          "${lib.getExe pkgs.unstable.alejandra}"
        ];

        "remote.SSH.useLocalServer" = false;

        "redhat.telemetry.enabled" = false;

        "search.followSymlinks" = false;

        "telemetry.telemetryLevel" = "off";

        "terminal.integrated.fontFamily" = mkDefault "'FiraCode Nerd Font', 'monospace'";
        "terminal.integrated.cursorStyle" = mkDefault "line";
        "terminal.integrated.defaultProfile.osx" =
          mkIf config.JenSeReal.programs.shells.nushell.enable "nu";

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

        "update.mode" = "none";
      };

      extensions = with marketplace;
        [
          yzhang.markdown-all-in-one
          asciidoctor.asciidoctor-vscode
          tamasfe.even-better-toml
          redhat.vscode-yaml
          kennylong.kubernetes-yaml-formatter
          ms-azuretools.vscode-docker
          usernamehw.errorlens
          cordx56.rustowl-vscode
          shardulm94.trailing-spaces
          christian-kohler.path-intellisense
          vscode-icons-team.vscode-icons
          redhat.vscode-xml
          oderwat.indent-rainbow
          rust-lang.rust-analyzer
          fill-labs.dependi
          tauri-apps.tauri-vscode
          editorconfig.editorconfig
          # vadimcn.vscode-lldb
          pflannery.vscode-versionlens
          lorenzopirro.rust-flash-snippets
          zhangyue.rust-mod-generator
          jedeop.crates-completer
          jscearcy.rust-doc-viewer
          biomejs.biome
          rangav.vscode-thunder-client
          dotjoshjohnson.xml
          jgclark.vscode-todo-highlight
          gruntfuggly.todo-tree
          chrmarti.regex
          aaron-bond.better-comments
          ms-vsliveshare.vsliveshare
          pinage404.nix-extension-pack
          robbowen.synthwave-vscode
          ms-vscode-remote.vscode-remote-extensionpack
          formulahendry.docker-explorer
          redhat.java
          vscjava.vscode-java-test
          vscjava.vscode-java-debug
          vscjava.vscode-maven
          vscjava.vscode-java-dependency
          vscjava.vscode-spring-initializr
          vscjava.vscode-gradle
          codeium.codeium
          richardwillis.vscode-spotless-gradle
          mathiasfrohlich.kotlin
          myriad-dreamin.tinymist
          hashicorp.terraform
          mgtrrz.terraform-completer
          grafana.grafana-alloy
        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [];

      keybindings = [];
    };

    # };

    home.file = lib.genAttrs pathsToMakeWritable (_: {
      force = true;
      mutable = true;
    });
  };
}
