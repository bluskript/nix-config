{ inputs, ... }: {
  programs.firefox = {
  	enable = true;
    profiles = {
      Default = {
        extraConfig = (builtins.readFile ./user.js);
      };
    };
  };
}
