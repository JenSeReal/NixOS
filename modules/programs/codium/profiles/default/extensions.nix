{
  delib,
  pkgs,
  inputs,
  ...
}:
delib.module {
  name = "programs.codium";

  home.ifEnabled = {...}: let
    marketplace = inputs.nix-vscode-extensions.extensions.${pkgs.stdenv.hostPlatform.system}.vscode-marketplace;
  in {
    programs.vscode.profiles.default.extensions = with marketplace;
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
        # fill-labs.dependi
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
        robbowen.synthwave-vscode
        # ms-vscode-remote.remote-ssh
        # ms-vscode.remote-server
        # ms-vscode-remote.remote-containers
        # ms-vscode-remote.remote-wsl
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
        # hashicorp.terraform
        mgtrrz.terraform-completer
        grafana.grafana-alloy
        notblank00.hexeditor
        jnoortheen.nix-ide
        mkhl.direnv
        arrterian.nix-env-selector
        opentofu.vscode-opentofu
      ]
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [];
  };
}
