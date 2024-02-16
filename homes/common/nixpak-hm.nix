# Apply settings from home-manager config to the nixpak environment to make it consistent
{
  config,
  pkgs,
}: let
  lib = pkgs.lib;
  maybeTheme = opt: lib.findFirst builtins.isNull opt.package [opt opt.package];
  just' = v: lib.optional (v != null);
  just = v: just' v v;

  gtkTheme = maybeTheme config.gtk.theme;
  iconTheme = maybeTheme config.gtk.iconTheme;
  cursorTheme = maybeTheme config.home.pointerCursor;
in {
  bubblewrap = {
    bind.ro = [] ++ just' cursorTheme "${cursorTheme}";
    env = {
      XDG_DATA_DIRS = lib.mkForce (lib.makeSearchPath "share" ([
          pkgs.shared-mime-info
        ]
        ++ just iconTheme
        ++ just gtkTheme
        ++ just cursorTheme));
      XCURSOR_PATH = lib.mkIf (cursorTheme != null) (lib.mkForce (lib.concatStringsSep ":" [
        "${cursorTheme}/share/icons"
        "${cursorTheme}/share/pixmaps"
      ]));
    };
  };
}
