{pkgs, ...}: let
  blusk = import ../../identities/blusk.nix;
in {
  users.mutableUsers = false;

  users.users.root.initialHashedPassword = "$6$1l3TCl1ZMdmM.SQx$pmpbS5C37.XMxMihuhMzZO5gso5IZh47NP6Dg61C.Eu1jHrA.rx4xgkFSHud.d3mxV6cJxQ3GH1ZKS/nLoFHt1";

  programs.zsh.enable = true;

  users.users = {
    blusk = {
      home = "/home/blusk";
      createHome = true;
      shell = pkgs.zsh;
      description = "mia";
      initialHashedPassword = "$6$1l3TCl1ZMdmM.SQx$pmpbS5C37.XMxMihuhMzZO5gso5IZh47NP6Dg61C.Eu1jHrA.rx4xgkFSHud.d3mxV6cJxQ3GH1ZKS/nLoFHt1";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        blusk.pubkey
      ];
      extraGroups = ["wheel" "networkmanager" "audio" "video" "adbusers" "wireshark" "libvirtd" "podman"];
    };
  };
}
