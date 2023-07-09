{pkgs, ...}: let
  custom_commands = [
    ./fzf_content_open.py
  ];
  commandsPy = builtins.concatStringsSep "\n" ([
      "from ranger.api.commands import Command"
    ]
    ++ (map builtins.readFile custom_commands));
in {
  home.packages = with pkgs; [ranger xdragon skim bat ripgrep];
  xdg.configFile."ranger/rc.conf".text = ''
    map <C-d> shell xdragon -a -x %p
    map <C-f> fzf_content_open
  '';
  xdg.configFile."ranger/commands.py".text = commandsPy;
}
