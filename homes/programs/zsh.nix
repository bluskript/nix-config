{ config, ... }: {
  programs.zsh = {
    enable = true;
    autocd = true;
    enableVteIntegration = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    dotDir = ".config/zsh";
    history.path = "${config.home.homeDirectory}/.local/share/zsh/history";
    initExtra = ''
      # zsh must answer for its sins
      source ~/.profile
      # cute menu that shows up when completion
      zstyle ':completion:*' menu select
      bindkey -e
      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;5D" backward-word
    '';
  };
}

