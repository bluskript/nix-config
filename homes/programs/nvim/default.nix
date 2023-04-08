{ nixosConfig, config, lib, pkgs, ... }:
{
  stylix.targets.vim.enable = false;
  home.sessionVariables.EDITOR = "nvim";
  home.packages = with pkgs; [ gcc ];
  home.activation = {
    linkNvimConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
      ln -sfr /etc/nixos/homes/programs/nvim/config/* ${config.home.homeDirectory}/.config/nvim
    '';
  };
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withNodeJs = false;
    withRuby = false;
    withPython3 = false;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };
}
