{...}: {
  programs.git = {
    enable = true;
    userName = "Blusk";
    userEmail = "bluskript@gmail.com";
    extraConfig = {
      push = {
        autoSetupRemote = true;
      };
      # gpg.format = "ssh";
    };
    aliases = {
      co = "checkout";
      d = "clone --depth 1";
      c = "commit";
      cam = "commit --amend";
    };
  };
}
