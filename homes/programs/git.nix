{pkgs, ...}: let
  globalGitignore =
    pkgs.writeText ".gitignore"
    ''
      .direnv
    '';
in {
  programs.git = {
    enable = true;
    userName = "Blusk";
    userEmail = "bluskript@gmail.com";
    signing = {
      signByDefault = true;
      key = "0x5F7286501D9A677D";
    };
    extraConfig = {
      init.defaultBranch = "main";
      push = {
        autoSetupRemote = true;
      };
      core.excludesfile = "${globalGitignore}";
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
