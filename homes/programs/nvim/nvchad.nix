{ config, lib, pkgs, ... }:

let
  nvchad = pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "nvchad";
    version = "unstable-2023-02-16";
    src = pkgs.fetchFromGitHub {
      owner = "NvChad";
      repo = "NvChad";
      rev = "d7f91016a864f1397d24c899d4f9a4d4b42e2945";
      sha256 = "sha256-Ykl6/4KlKGDyLD5oNUi6CCl501bO5o352/1V0Y0Ke9M=";
    };
    meta.homepage = "https://github.com/NvChad/NvChad/";
  };
in

{
  programs.neovim = {
    # plugins = [ nvchad pkgs.vimPlugins.telescope-fzf-native-nvim ];
    plugins = [ nvchad ];
  };
  xdg.configFile."nvim/init.lua".text = ''
    vim.cmd [[source ${nvchad}/init.lua]]
  '';
  xdg.configFile."nvim/lua/custom".source = ./nvchad;
  xdg.configFile."nvim/lua/telescope".source = ./telescope;
}
