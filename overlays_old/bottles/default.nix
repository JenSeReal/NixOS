{...}: final: prev: {
  bottles = prev.bottles.override {removeWarningPopup = true;};
  bottles-unwrapped = prev.bottles-unwrapped.override {removeWarningPopup = true;};
}
