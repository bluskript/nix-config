{ inputs, pkgs, config, ... }:
let
  scheme = (config.lib.stylix.colors { template = builtins.readFile (./default.mustache); });
in
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ''
      @import "${scheme}";
      ${builtins.readFile (./style.css)}
    '';
  };
}
