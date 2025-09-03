{delib, ...}:
delib.module {
  name = "programs.aerospace";

  home.ifEnabled = {...}: {
    programs.aerospace.userSettings = {
      accordion-padding = 10;

      on-focused-monitor-changed = ["move-mouse monitor-lazy-center"];

      gaps = {
        inner.horizontal = 0;
        inner.vertical = 0;
        outer.left = 0;
        outer.bottom = 0;
        outer.top = 0;
        outer.right = 0;
      };
    };
  };
}
