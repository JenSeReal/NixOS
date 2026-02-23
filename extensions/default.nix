{delib}: (with delib.extensions; [
  args
  (base.withConfig {
    args.enable = true;
  })
  (overlays.withConfig {
    defaultTargets = [
      "nixos"
      "darwin"
    ];
  })
  (delib.callExtension ./package-module.nix)
  (delib.callExtension ./deploy.nix)
])
