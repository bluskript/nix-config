{ ... }: {
  imports = [
    ./base_cli.nix
    ../nix.nix
    ../boot.nix
    ../auth.nix
    ../audio.nix
    ../video.nix
    ../fonts.nix
    ../printing.nix
    ../networking/dns.nix
    ../networking/sshd.nix
    ../networking/podman.nix
  ];

  dns.encryption.enable = true;
  networking.networkmanager.enable = true;
}
