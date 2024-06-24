{lib, ...}: {
  networking = {
    dhcpcd.extraConfig = "nohook resolv.conf";
    networkmanager = {
      dns = lib.mkForce "none";
    };
  };
}
