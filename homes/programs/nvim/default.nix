{
  nixosConfig,
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

      rust-analyzer
      sumneko-lua-language-server
      nodePackages_latest.typescript-language-server
      nodePackages_latest.pyright

      nodePackages_latest.prettier
      nodePackages_latest.eslint
      stylua
      alejandra
      nixd
    ];
    plugins = with pkgs.vimPlugins; [
      # this does yucky yarn stuff
      markdown-preview-nvim
    ];
    defaultEditor = true;
    withNodeJs = false;
    withRuby = false;
    withPython3 = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };
}
