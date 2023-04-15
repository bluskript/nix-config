{ pkgs, config, ... }: {
  programs.zsh = {
    enable = true;
    autocd = true;
    enableVteIntegration = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    dotDir = ".config/zsh";
    history.path = "${config.home.homeDirectory}/.local/share/zsh/history";
    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.5.0";
          sha256 = "0za4aiwwrlawnia4f29msk822rj9bgcygw6a8a6iikiwzjjz0g91";
        };
      }
    ];
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

