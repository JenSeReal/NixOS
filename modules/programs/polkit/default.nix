{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.polkit";
  options = delib.singleEnableOption false;

  nixos.ifEnabled = {...}: {
    environment.systemPackages = with pkgs; [kdePackages.polkit-kde-agent-1];

    security.polkit = {
      enable = true;
    };

    systemd = {
      user.services.polkit-kde-authentication-agent-1 = {
        after = ["graphical-session.target"];
        description = "polkit-kde-authentication-agent-1";
        wantedBy = ["graphical-session.target"];
        wants = ["graphical-session.target"];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };
  };
}
