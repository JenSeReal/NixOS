{ delib }:
(with delib.extensions; [
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
])
