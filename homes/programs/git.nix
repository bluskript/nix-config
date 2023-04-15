{ ... }: {
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
  };
}
