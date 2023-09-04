{pkgs, ...}: let
  neovideConfig = {
    multigrid = true;
  };
  tomlFormat = pkgs.formats.toml {};
in {
  home.packages = with pkgs; [neovide];
  xdg.configFile."neovide/config.toml".source = tomlFormat.generate "config.toml" neovideConfig;
}
