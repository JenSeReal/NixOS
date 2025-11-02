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
  home.ifEnabled = {...}: {
    programs.nvf = {
      enable = true;
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
    environment.systemPackages = with pkgs; [cfg.package neovide];
  };

  nixos.always = {
    imports = [inputs.nvf.nixosModules.default];
  };
  nixos.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [neovide];
    programs.nvf = {
      enable = true;
      settings = {
        vim.viAlias = true;
        vim.vimAlias = true;
        vim.lsp = {
          enable = true;
        };
      };
    };
  };
}
