{ inputs, ... }: {
  programs.firefox = {
  	enable = true;
    profiles = {
      Default = {
        id = 0;
        extraConfig = (builtins.readFile ./user.js);
      };
      Work = {
        id = 1;
      };
    };
  };
}
