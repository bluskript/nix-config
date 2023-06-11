{ config, lib, pkgs, ... }: {
  options.symlinks = with lib; {
    homeFiles = mkOption {
      type = types.attrs;
      default = { };
    };
    configFiles = mkOption {
      type = types.attrs;
      default = { };
    };
  };
  config =
    let
      cfg = config.symlinks;
      toSource = configDirName: dotfilesPath: { source = dotfilesPath; };
    in
    {
      home.file = pkgs.lib.attrsets.mapAttrs toSource cfg.homeFiles;
      xdg.configFile = pkgs.lib.attrsets.mapAttrs toSource cfg.configFiles;
    };
}
