{
  pkgs,
  config,
  ...
}: {
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
    shellAliases = {
      "nvcfg" = "ranger ~/.config/nvim/";
    };
    initExtra = ''
      # zsh must answer for its sins
      source ~/.profile
      # cute menu that shows up when completion
      zstyle ':completion:*' menu select
      bindkey -e
      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;5D" backward-word

      # auto set window titles
      preexec() { print -Pn "\e]0;$1%~\a" }

      # shell gpt shortcut
      _sgpt_zsh() {
      if [[ -n "$BUFFER" ]]; then
          _sgpt_prev_cmd=$BUFFER
          BUFFER+="⌛"
          zle -I && zle redisplay
          BUFFER=$(sgpt --shell <<< "$_sgpt_prev_cmd")
          zle end-of-line
      fi
      }
      zle -N _sgpt_zsh
      # Ctrl+L
      bindkey ^l _sgpt_zsh

      _sgpt_repl() {
        BUFFER="sgpt --repl temp"
        zle accept-line
      }

      zle -N _sgpt_repl

      bindkey \^K _sgpt_repl
    '';
  };
}
