{
  inputs,
  outputs,
  nixosConfig,
  ...
}: {
  imports = [
    inputs.nix-index-database.hmModules.nix-index
    ../programs/starship.nix
    ../programs/git.nix
    ../programs/gpg.nix
    ../programs/skim.nix
    ../programs/zoxide.nix
    ../programs/zsh.nix
    ../programs/nushell
    ../programs/carapace.nix
    ../programs/direnv.nix
  ];

  home.shellAliases = nixosConfig.environment.shellAliases;

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  programs.command-not-found.enable = true;
  programs.nix-index-database.comma.enable = true;
  programs.nix-index = {
    enable = true;
    enableBashIntegration = false;
    enableZshIntegration = false;
  };
}
