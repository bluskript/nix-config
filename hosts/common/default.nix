{ lib, ... }: with lib; {
  imports = [
    ./nix.nix
    ./auth.nix
    ./boot.nix
    ./video.nix
    ./audio.nix
    ./networking/dns.nix
    ./networking/sshd.nix
  ];

  options = {
    computer = {
      isLaptop = mkEnableOption "laptop-related defaults";
    };
  };
}
