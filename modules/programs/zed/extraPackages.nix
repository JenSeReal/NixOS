{
  delib,
  pkgs,
  lib,
  ...
}:
delib.module {
  name = "programs.zed";

  home.ifEnabled = {...}: {
    programs.zed-editor.extraPackages = with pkgs; [
      nil
      nixd
      alejandra
      direnv
      devenv
      hexyl
      rust-analyzer
      opentofu
      opentofu-ls
      (runCommand "terraform" {} ''
        mkdir -p "$out"/bin
        ln -s ${lib.getExe opentofu} "$out"/bin/terraform
      '')
      (runCommand "terraform-ls" {} ''
        mkdir -p "$out"/bin
        ln -s ${lib.getExe opentofu-ls} "$out"/bin/terraform-ls
      '')
      yaml-language-server
      treefmt
      biome
      yamlfmt
      jsonfmt
      taplo
    ];
  };
}
