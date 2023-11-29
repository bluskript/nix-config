{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  nvimBase16 = pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "nvim-base16";
    version = "6247ca9aa9f34644dfa290a6df3f6feefb73eb97";
    src = pkgs.fetchFromGitHub {
      owner = "RRethy";
      repo = "nvim-base16";
      rev = "6247ca9aa9f34644dfa290a6df3f6feefb73eb97";
      sha256 = "sha256-jrQ2/6KQaG4FR5mslBmcEPdBbuhrWy2Ay49zQwCD0y0=";
    };
  };
in {
  home.activation = {
    linkNvimConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
      mkdir -p ${config.home.homeDirectory}/.config/nvim
      ln -sfr /etc/nixos/homes/programs/nvim/config/* ${config.home.homeDirectory}/.config/nvim
    '';
  };
  programs.neovim = {
    enable = true;
    extraPackages = with pkgs; [
      tree-sitter
      gcc
      stdenv.cc
      xxd

      nil
      # rust-analyzer
      # terraform-lsp
      # nodePackages_latest.pyright
      # sumneko-lua-language-server
      vscode-langservers-extracted
      # haskell-language-server
      nodePackages_latest.yaml-language-server
      # nodePackages_latest.typescript-language-server
      # nodePackages_latest.dockerfile-language-server-nodejs
      # # scala
      # metals
      # # c/cpp
      # clang-tools
      # gopls

      # nodePackages_latest.prettier
      # nodePackages_latest.eslint
      stylua
      alejandra
    ];
    plugins = with pkgs.vimPlugins; [
      # this does yucky yarn stuff
      markdown-preview-nvim
      nvimBase16
    ];

    viAlias = true;
    vimAlias = true;
    withRuby = false;
    withNodeJs = false;
    withPython3 = false;
    vimdiffAlias = true;
    defaultEditor = true;
  };
}
