{delib, ...}:
delib.module {
  name = "programs.aerospace";

  home.ifEnabled = {...}: {
    programs.aerospace.userSettings.on-window-detected = [
      {
        "if".app-id = "com.apple.systempreferences";
        run = "layout floating";
      }
      {
        "if".app-id = "org.openvpn.client.app";
        run = "layout floating";
      }
      {
        "if".app-id = "org.mozilla.firefox";
        run = "move-node-to-workspace internet";
      }
      {
        "if".app-id = "com.microsoft.VSCode";
        run = "move-node-to-workspace code";
      }
      {
        "if".app-id = "com.apple.Terminal";
        run = "move-node-to-workspace terminal";
      }
      {
        "if".app-id = "net.kovidgoyal.kitty";
        run = "move-node-to-workspace terminal";
      }
      {
        "if".app-id = "com.github.wez.wezterm";
        run = "move-node-to-workspace terminal";
      }

      {
        "if".app-id = "com.electron.realtimeboard";
        run = "move-node-to-workspace productive";
      }

      {
        "if".app-id = "com.microsoft.onenote.mac";
        run = "move-node-to-workspace notes";
      }

      {
        "if".app-id = "com.electron.logseq";
        run = "move-node-to-workspace notes";
      }
      {
        "if".app-id = "com.spotify.client";
        run = "move-node-to-workspace notes";
      }
      {
        "if".app-id = "com.tinyspeck.slackmacgap";
        run = "move-node-to-workspace chat";
      }
      {
        "if".app-id = "com.microsoft.Outlook";
        run = "move-node-to-workspace chat";
      }
      {
        "if".app-id = "com.microsoft.teams2";
        run = "move-node-to-workspace conference";
      }
      {
        "if".app-id = "us.zoom.xos";
        run = "move-node-to-workspace conference";
      }
    ];
  };
}
