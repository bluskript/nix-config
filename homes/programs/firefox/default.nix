{ inputs, ... }: {
  programs.firefox = {
    enable = true;
    profiles = {
      Default = {
        id = 0;
        extraConfig = (builtins.readFile ./user.js);
        userChrome = (builtins.readFile ./userChrome.css);
      };
      Work = {
        id = 1;
      };
    };
  };
}
