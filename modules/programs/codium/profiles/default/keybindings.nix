{delib, ...}:
delib.module {
  name = "programs.vscode";

  home.ifEnabled = {...}: {
    programs.vscode.profiles.default.keybindings = [
      {
        "key" = "cmd+'";
        "command" = "editor.action.commentLine";
        "when" = "editorTextFocus && !editorReadonly";
      }
      {
        "key" = "cmd+/";
        "command" = "-editor.action.commentLine";
        "when" = "editorTextFocus && !editorReadonly";
      }
      {
        "key" = "shift+cmd+'";
        "command" = "editor.action.blockComment";
        "when" = "editorTextFocus && !editorReadonly";
      }
      {
        "key" = "shift+alt+a";
        "command" = "-editor.action.blockComment";
        "when" = "editorTextFocus && !editorReadonly";
      }
    ];
  };
}
