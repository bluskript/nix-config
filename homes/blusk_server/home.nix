{ ... }: {
  imports = [
    ../common/profile-cli.nix
  ];
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}
