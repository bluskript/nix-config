{...}: {
  programs.firefox = {
    enable = true;
    profiles = {
      Default = {
        id = 0;
        extraConfig = builtins.readFile ./user.js;
        userChrome = builtins.readFile ./userChrome.css;
        settings = {
          "identity.sync.tokenserver.uri" = "https://firefox.blusk.dev/1.0/sync/1.5";
        };
      };
      Work = {
        id = 1;
      };
    };
  };
}
