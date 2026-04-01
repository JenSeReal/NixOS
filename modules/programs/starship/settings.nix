{delib, ...}:
delib.module {
  name = "programs.starship";

  home.ifEnabled = {...}: {
    programs.starship.settings = {
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[✗](bold red) ";
      };
      time = {
        disabled = false;
        format = ''🕙[$time]($style)'';
      };
      right_format = "$time";
      kubernetes = {
        disabled = false;
      };
    };
  };
}
