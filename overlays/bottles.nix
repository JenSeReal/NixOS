{delib, ...}:
delib.overlayModule {
  name = "bottles";
  overlay = final: prev: {
    bottles = prev.bottles.override {
      removeWarningPopup = true;
    };
  };
}
