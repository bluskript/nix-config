{...}: {
  imports = [./pc.nix];

  programs.captive-browser = {
    enable = true;
    dhcp-dns = "nmcli --terse --get-values IP4.DNS device show";
    interface = "wlp0s20f3";
  };
}
