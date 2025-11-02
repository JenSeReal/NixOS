{
  delib,
  pkgs,
  inputs,
  ...
}:
delib.module {
  name = "programs.neovim";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption pkgs.unstable.neovim;
    };

  home.always = {
    imports = [inputs.nvf.homeManagerModules.default];
  };
  home.ifEnabled = {cfg, ...}: {
    programs.nvf = {
      enable = true;
      package = cfg.package;
      settings = {
        vim.viAlias = true;
        vim.vimAlias = true;
        vim.lsp = {
          enable = true;
        };
      };
    };
  };

  darwin.ifEnabled = {cfg, ...}: {
    environment.systemPackages = [cfg.package];
  };

  nixos.always = {
    imports = [inputs.nvf.nixosModules.default];
  };
  nixos.ifEnabled = {cfg, ...}: {
    programs.nvf = {
      enable = true;
      package = cfg.package;
      settings = {
        vim.viAlias = true;
        vim.vimAlias = true;
        vim.lsp = {
          enable = true;
        };
      };
    };
    # programs.neovim = {
    #   enable = true;
    #   package = cfg.package;
    #   defaultEditor = true;
    #   viAlias = true;
    #   vimAlias = true;
    # };
  };
}
