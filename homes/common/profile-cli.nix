{inputs, ...}: {
  imports = [
    inputs.nix-index-database.hmModules.nix-index
    ../programs/nvim
    ../programs/starship.nix
    ../programs/git.nix
    ../programs/skim.nix
    ../programs/zoxide.nix
    ../programs/zsh.nix
    ../programs/direnv.nix
  ];

  programs.command-not-found.enable = true;
  programs.nix-index-database.comma.enable = true;
  programs.nix-index = {
    enable = true;
    enableBashIntegration = false;
    enableZshIntegration = false;
  };
}
