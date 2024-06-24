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
    syntaxHighlighting = {
      enable = true;
    };
    dotDir = ".config/zsh";
    history.path = "${config.home.homeDirectory}/.local/share/zsh/history";
    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.7.0";
          sha256 = "149zh2rm59blr2q458a5irkfh82y3dwdich60s9670kl3cl5h2m1";
        };
      }
    ];
    shellAliases = {
      "nvcfg" = "ranger /etc/nixos/homes/programs/nvim/config/lua/config";
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
