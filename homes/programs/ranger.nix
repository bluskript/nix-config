{ pkgs, ... }: {
  home.packages = with pkgs; [ ranger xdragon ];
  xdg.configFile."ranger/rc.conf".text = ''
    map <C-d> shell xdragon -a -x %p
  '';
}
