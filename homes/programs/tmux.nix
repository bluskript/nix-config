{...}: {
  programs.tmux = {
    enable = true;
    extraConfig = ''
      set-option -sa terminal-overrides ",alacritty*:Tc"
      set -s escape-time 0
    '';
  };
}
