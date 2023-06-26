{
  pkgs,
  builtins,
  ...
}: let
  commandsPy = builtins.concatStringsSep "\n" (builtins.readFile ./fzf_content_open.py);
in {
  home.packages = with pkgs; [ranger xdragon];
  xdg.configFile."ranger/rc.conf".text = ''
    map <C-d> shell xdragon -a -x %p
  '';
}
