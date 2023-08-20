{
  config,
  lib,
  pkgs,
  ...
}: {
  # stylix.targets.vim.enable = false;
  home.sessionVariables.EDITOR = "nvim";
  home.activation = {
    linkNvimConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
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
