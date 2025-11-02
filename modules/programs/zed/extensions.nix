{delib, ...}:
delib.module {
  name = "programs.zed";

  home.ifEnabled = {...}: {
    programs.zed-editor.extensions = [
      "biome"
      "env"
      "git-firefly"
      "nix"
      "toml"
      "terraform"
    ];
  };
}
