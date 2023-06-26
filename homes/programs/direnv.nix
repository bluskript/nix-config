{...}: {
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    # has cache problems
    # nix-direnv.enable = true;
  };
}
