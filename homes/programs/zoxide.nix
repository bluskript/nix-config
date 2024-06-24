{...}: {
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.zsh.initExtra = "bindkey -s '^f' 'zi^M'";
}
