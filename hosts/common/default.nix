{ lib, ... }: with lib; {
  imports = [
    ./nix.nix
    ./auth.nix
    ./boot.nix
    ./dns.nix
    ./sshd.nix
    ./video.nix
    ./audio.nix
  ];

  options = {
    computer = {
      isLaptop = mkEnableOption "laptop-related defaults";
    };
  };
}
