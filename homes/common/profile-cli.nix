{inputs, nixosConfig, ...}: {
  imports = [
    inputs.nix-index-database.hmModules.nix-index
    ../programs/starship.nix
    ../programs/git.nix
    ../programs/gpg.nix
    ../programs/skim.nix
    ../programs/zoxide.nix
    ../programs/zsh.nix
    ../programs/nushell
    ../programs/direnv.nix
  ];

  home.shellAliases = nixosConfig.environment.shellAliases;


  programs.command-not-found.enable = true;
  programs.nix-index-database.comma.enable = true;
  programs.nix-index = {
    enable = true;
    enableBashIntegration = false;
    enableZshIntegration = false;
  };
}
