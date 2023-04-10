{ nixosConfig, config, lib, pkgs, ... }:
{
  # stylix.targets.vim.enable = false;
  home.sessionVariables.EDITOR = "nvim";
  home.activation = {
    linkNvimConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p ${config.home.homeDirectory}/.config/nvim
      ln -sfr /etc/nixos/homes/programs/nvim/config/* ${config.home.homeDirectory}/.config/nvim
    '';
  };
  programs.neovim = {
    enable = true;
    extraLuaConfig = ''
      require('config.init_custom')
    '';
    extraPackages = with pkgs; [
      tree-sitter
      gcc
      rust-analyzer
      sumneko-lua-language-server
      nodePackages_latest.typescript-language-server
      rnix-lsp
      nixpkgs-fmt
      stylua
    ];
    defaultEditor = true;
    withNodeJs = false;
    withRuby = false;
    withPython3 = false;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };
}
