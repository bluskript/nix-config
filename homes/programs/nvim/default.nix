{ nixosConfig, config, lib, pkgs, ... }:
let
  boole = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "boole";
    src = pkgs.fetchFromGitHub {
      owner = "nat-418";
      repo = "boole.nvim";
      rev = "f4f9996f91159e54b8f1893b20e2e599c91bc1bd";
      sha256 = "sha256-796O0FodHGupxVHNUM7jTnG9yIvMX3zA7TzbU17gNE4=";
    };
  };
in
{
  # Clear all caches
  # rm -rf ~/.config/nvim/plugin/packer_compiled.lua ~/.cache/nvim/ ~/.local/share/nvim/site/
  imports = [
    # ./nvchad.nix
    ./update-nix-fetchgit.nix
  ];
  # workaround for https://github.com/lewis6991/impatient.nvim/issues/42
  # home.activation.neovim = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  #   $DRY_RUN_CMD rm -f $VERBOSE_ARG ~/.cache/nvim/luacache_chunks ~/.cache/nvim/luacache_modpaths
  # '';
  home.sessionVariables.EDITOR = "nvim";
  programs.neovim = {
    enable = true;
    extraPackages = with pkgs; [
      gcc
      nixpkgs-fmt
      rnix-lsp
      sumneko-lua-language-server
      terraform-ls
      tree-sitter
      yaml-language-server
      nodePackages_latest.typescript
      nodePackages_latest.typescript-language-server
    ] ++ lib.optionals (builtins.hasAttr "stylua" pkgs) [ stylua ];
    plugins = with pkgs.vimPlugins; [
      csv-vim
      vim-jsonnet
      vim-nix
      boole
    ] ++ (with pkgs.vimExtraPlugins; [
      prettier-nvim
    ]);
    withNodeJs = false;
    withRuby = false;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };
}
