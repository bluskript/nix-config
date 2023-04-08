{ nixosConfig, config, lib, pkgs, ... }:
{
  home.sessionVariables.EDITOR = "nvim";
  xdg.configFile."nvim/init.lua".source = ./config/init.lua;
  xdg.configFile."nvim/lua".source = ./config/lua;
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
