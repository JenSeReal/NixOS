{delib, ...}:
delib.module {
  name = "features.shell-tools";
  options = with delib;
    moduleOptions {
      enable = boolOption false;
    };

  myconfig.ifEnabled = {...}: {
    programs = {
      # Better alternatives to classic tools
      bat.enable = true; # better cat
      eza.enable = true; # better ls
      lsd.enable = true; # alternative ls
      fd.enable = true; # better find
      ripgrep.enable = true; # better grep
      rip.enable = true; # better rm (safe delete)
      zoxide.enable = true; # better cd
      dust.enable = true; # better du
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
      thefuck.enable = true; # command correction
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
}
