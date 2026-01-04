{delib}: (with delib.extensions; [
  args
  (base.withConfig {
    args.enable = true;
  })
  (overlays.withConfig {
    defaultTargets = [
      "nixos"
      "home"
      "darwin"
    ];
  })
  (delib.callExtension ./package-module.nix)
  (delib.callExtension ./deploy.nix)
])
