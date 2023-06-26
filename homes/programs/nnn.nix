{
  stdenv,
  pkgs,
  lib,
  ...
}: let
  pluginList = ["preview-tui"];
  pluginsGit =
    (pkgs.fetchFromGitHub {
      owner = "jarun";
      repo = "nnn";
      rev = "18b5371d08e341ddefd2d023e3f7d201cac22b89";
      sha256 = "sha256-L6p7bd5XXOHBZWei21czHC0N0Ne1k2YMuc6QhVdSxcQ=";
    })
    + "/plugins";
  plugins = pkgs.stdenv.mkDerivation {
    name = "nnn-plugins-blusk-1.0";
    src = pluginsGit;
    installPhase = ''
      mkdir -p $out
      cp ${lib.concatStringsSep " " pluginList} $out
    '';
  };
in {
  home.sessionVariables."NNN_FIFO" = "/tmp/nnn.fifo";
  programs.nnn = {
    enable = true;
    plugins = {
      src = plugins;
    };
  };
}
