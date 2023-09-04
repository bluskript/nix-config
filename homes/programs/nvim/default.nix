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
  # stylix.targets.vim.enable = false;
  home.activation = {
    linkNvimConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
      mkdir -p ${config.home.homeDirectory}/.config/nvim
      ln -sfr /etc/nixos/homes/programs/nvim/config/* ${config.home.homeDirectory}/.config/nvim
    '';
  };
  stylix.targets.vim.enable = false;
  programs.neovim = {
    enable = true;
    extraLuaConfig = builtins.readFile (config.lib.stylix.colors {
      template = ''
        require('base16-colorscheme').setup({
          base00 = '#{{base00-hex}}', base01 = '#{{base01-hex}}', base02 = '#{{base02-hex}}', base03 = '#{{base03-hex}}',
          base04 = '#{{base04-hex}}', base05 = '#{{base05-hex}}', base06 = '#{{base06-hex}}', base07 = '#{{base07-hex}}',
          base08 = '#{{base08-hex}}', base09 = '#{{base09-hex}}', base0A = '#{{base0A-hex}}', base0B = '#{{base0B-hex}}',
          base0C = '#{{base0C-hex}}', base0D = '#{{base0D-hex}}', base0E = '#{{base0E-hex}}', base0F = '#{{base0F-hex}}',
        })
        require('config.init_custom')
      '';
    });
    extraPackages = with pkgs; [
      tree-sitter
      gcc
      stdenv.cc
      xxd

      nil
      rust-analyzer
      terraform-lsp
      nodePackages_latest.pyright
      sumneko-lua-language-server
      vscode-langservers-extracted
      nodePackages_latest.yaml-language-server
      nodePackages_latest.typescript-language-server
      nodePackages_latest.dockerfile-language-server-nodejs

      nodePackages_latest.prettier
      nodePackages_latest.eslint
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
    withPython3 = true;
    vimdiffAlias = true;
    defaultEditor = true;
  };
}
