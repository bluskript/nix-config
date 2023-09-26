{pkgs, ...}: {
  programs.pidgin = {
    enable = true;
    plugins = with pkgs; [purple-slack purple-discord purple-matrix];
  };
}
