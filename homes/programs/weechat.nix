{pkgs, ...}: {
  home.packages = let
    weechat = pkgs.wrapWeechat pkgs.weechat-unwrapped {};
  in [
    (weechat.override {
      configure = {availablePlugins, ...}: {
        scripts = with pkgs.weechatScripts; [
          wee-slack
          multiline
          weechat-matrix
        ];
        plugins = [
          availablePlugins.python
          availablePlugins.perl
          availablePlugins.lua
        ];
      };
    })
  ];
}
