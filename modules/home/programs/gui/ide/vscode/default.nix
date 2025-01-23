{
  config,
  lib,
  inputs,
  pkgs,
  system,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption mkDefault;
  cfg = config.JenSeReal.programs.gui.ide.vscode;

  is-darwin = pkgs.stdenv.isDarwin;

  extensions = inputs.nix-vscode-extensions.extensions.${system}.vscode-marketplace;

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

        "[nix][toml][rust][adoc][markdown][yaml]" = {
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
      };

      extensions = [
        extensions.yzhang.markdown-all-in-one
        extensions.asciidoctor.asciidoctor-vscode
        extensions.tamasfe.even-better-toml
        extensions.redhat.vscode-yaml
        extensions.ms-azuretools.vscode-docker
        extensions.usernamehw.errorlens
        extensions.shardulm94.trailing-spaces
        extensions.christian-kohler.path-intellisense
        extensions.vscode-icons-team.vscode-icons
        extensions.redhat.vscode-xml
        extensions.oderwat.indent-rainbow
        extensions.rust-lang.rust-analyzer
        extensions.fill-labs.dependi
        extensions.vadimcn.vscode-lldb
        extensions.pflannery.vscode-versionlens
        extensions.lorenzopirro.rust-flash-snippets
        extensions.zhangyue.rust-mod-generator
        extensions.jedeop.crates-completer
        extensions.jscearcy.rust-doc-viewer
        extensions.biomejs.biome
        extensions.rangav.vscode-thunder-client
        extensions.dotjoshjohnson.xml
        extensions.jgclark.vscode-todo-highlight
        extensions.gruntfuggly.todo-tree
        extensions.chrmarti.regex
        extensions.aaron-bond.better-comments
        extensions.ms-vsliveshare.vsliveshare
        extensions.pinage404.nix-extension-pack
        extensions.robbowen.synthwave-vscode
        extensions.ms-vscode-remote.vscode-remote-extensionpack
        extensions.formulahendry.docker-explorer
        extensions.redhat.java
        extensions.vscjava.vscode-java-test
        extensions.vscjava.vscode-java-debug
        extensions.vscjava.vscode-maven
        extensions.vscjava.vscode-java-dependency
        extensions.vscjava.vscode-spring-initializr
        extensions.vscjava.vscode-gradle
        extensions.codeium.codeium
        extensions.richardwillis.vscode-spotless-gradle
        extensions.mathiasfrohlich.kotlin
        extensions.myriad-dreamin.tinymist
        extensions.hashicorp.terraform
        extensions.mgtrrz.terraform-completer

      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [ ];

      keybindings = [ ];
    };

    home.file = lib.genAttrs pathsToMakeWritable (_: {
      force = true;
      mutable = true;
    });
  };
}
