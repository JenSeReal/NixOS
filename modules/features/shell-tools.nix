{
  delib,
  lib,
  ...
}:
delib.module {
  name = "features.shell-tools";
  options = with delib; let
    inherit (lib) mkOption types;
  in
    moduleOptions {
      enable = boolOption false;

      # Shell alias configuration
      aliases = {
        # Modern tool replacements
        cd = boolOption true; # zoxide instead of cd
        ls = boolOption true; # lsd instead of ls
        cat = boolOption true; # bat instead of cat
        grep = boolOption true; # ripgrep instead of grep
        find = boolOption true; # fd instead of find
        rm = boolOption true; # rip instead of rm
        cp = boolOption true; # xcp instead of cp
        du = boolOption true; # dust instead of du
        ps = boolOption true; # procs instead of ps
        diff = boolOption true; # delta/difftastic instead of diff
        sed = boolOption true; # sd instead of sed

        # Additional helpful aliases
        extra = mkOption {
          type = types.attrsOf types.str;
          default = {};
          description = "Additional custom shell aliases";
          example = {
            update = "sudo nixos-rebuild switch --flake .";
            ".." = "cd ..";
          };
        };
      };
    };

  myconfig.ifEnabled = {...}: {
    programs = {
      # Better alternatives to classic tools
      bat.enable = true; # better cat
      lsd.enable = true; # alternative ls
      fd.enable = true; # better find
      ripgrep.enable = true; # better grep
      rip.enable = true; # better rm (safe delete)
      zoxide.enable = true; # better cd
      dust.enable = true; # better du
      dua.enable = true; # better du
      pdu.enable = true; # parallel du
      delta.enable = true; # better diff
      difftastic.enable = true; # syntax-aware diff
      sd.enable = true; # better sed
      xcp.enable = true; # better cp (with progress)
      procs.enable = true; # better ps
      rnr.enable = true; # batch rename

      # Essential utilities
      fzf.enable = true; # fuzzy finder
      skim.enable = true; # alternative fuzzy finder
      btop.enable = true; # system monitor
      bottom.enable = true; # alternative system monitor
      microfetch.enable = true; # minimal system info
      macchina.enable = true; # system info
      curl.enable = true; # http client
      xh.enable = true; # modern http client
      dog.enable = true; # DNS lookup
      killall.enable = true; # process management
      yazi.enable = true; # file manager
      broot.enable = true; # directory navigation

      # Shell enhancements
      atuin.enable = true; # shell history
      pay-respects.enable = true; # command correction
      carapace.enable = true; # shell completions
      zellij.enable = true; # terminal multiplexer

      # Development tools
      direnv.enable = true; # environment management
      devenv.enable = true; # development environments
      git.enable = true; # version control
      neovim.enable = true; # text editor
      starship.enable = true; # shell prompt
    };
  };

  home.ifEnabled = {cfg, ...}: let
    # Helper to conditionally add aliases
    mkAlias = condition: aliases:
      if condition
      then aliases
      else {};
  in {
    programs.zsh.shellAliases =
      mkAlias cfg.aliases.cd {
        cd = "z";
      }
      // mkAlias cfg.aliases.ls {
        ls = "lsd";
        ll = "lsd -l";
        la = "lsd -la";
        lt = "lsd --tree";
      }
      // mkAlias cfg.aliases.cat {
        cat = "bat";
      }
      // mkAlias cfg.aliases.grep {
        grep = "rg";
      }
      // mkAlias cfg.aliases.find {
        find = "fd";
      }
      // mkAlias cfg.aliases.rm {
        rm = "rip";
      }
      // mkAlias cfg.aliases.cp {
        cp = "xcp";
      }
      // mkAlias cfg.aliases.du {
        du = "dust";
      }
      // mkAlias cfg.aliases.ps {
        ps = "procs";
      }
      // mkAlias cfg.aliases.diff {
        diff = "delta";
      }
      // mkAlias cfg.aliases.sed {
        sed = "sd";
      }
      // cfg.aliases.extra;

    programs.bash.shellAliases =
      mkAlias cfg.aliases.cd {
        cd = "z";
      }
      // mkAlias cfg.aliases.ls {
        ls = "lsd";
        ll = "lsd -l";
        la = "lsd -la";
        lt = "lsd --tree";
      }
      // mkAlias cfg.aliases.cat {
        cat = "bat";
      }
      // mkAlias cfg.aliases.grep {
        grep = "rg";
      }
      // mkAlias cfg.aliases.find {
        find = "fd";
      }
      // mkAlias cfg.aliases.rm {
        rm = "rip";
      }
      // mkAlias cfg.aliases.cp {
        cp = "xcp";
      }
      // mkAlias cfg.aliases.du {
        du = "dust";
      }
      // mkAlias cfg.aliases.ps {
        ps = "procs";
      }
      // mkAlias cfg.aliases.diff {
        diff = "delta";
      }
      // mkAlias cfg.aliases.sed {
        sed = "sd";
      }
      // cfg.aliases.extra;

    programs.fish.shellAliases =
      mkAlias cfg.aliases.cd {
        cd = "z";
      }
      // mkAlias cfg.aliases.ls {
        # ls = "lsd";
        # ll = "lsd -l";
        # la = "lsd -la";
        # lt = "lsd --tree";
      }
      // mkAlias cfg.aliases.cat {
        cat = "bat";
      }
      // mkAlias cfg.aliases.grep {
        grep = "rg";
      }
      // mkAlias cfg.aliases.find {
        find = "fd";
      }
      // mkAlias cfg.aliases.rm {
        rm = "rip";
      }
      // mkAlias cfg.aliases.cp {
        cp = "xcp";
      }
      // mkAlias cfg.aliases.du {
        du = "dust";
      }
      // mkAlias cfg.aliases.ps {
        ps = "procs";
      }
      // mkAlias cfg.aliases.diff {
        diff = "delta";
      }
      // mkAlias cfg.aliases.sed {
        sed = "sd";
      }
      // cfg.aliases.extra;
  };
}
