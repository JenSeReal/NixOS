{
  delib,
  inputs,
  ...
}:
delib.module {
  name = "mac-app-util";

  darwin.always = {...}: {
    imports = [
      inputs.mac-app-util.darwinModules.default
      inputs.home-manager.darwinModules.home-manager
      (
        {inputs, ...}: {
          home-manager.sharedModules = [
            inputs.mac-app-util.homeManagerModules.default
          ];
        }
      )
    ];
  };
}
