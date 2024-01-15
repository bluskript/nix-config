{pkgs, ...}: {
  stylix = let
    palette = ./themes/seqoia.yml;
  in {
    base16Scheme = palette;
    image = (import ../common/stylix.nix {inherit pkgs;}).processWallpaper palette 100 ../felys/lain.png;
    opacity = {
      applications = 0.8;
      desktop = 0.85;
      terminal = 0.8;
    };
    fonts.sizes = {
      terminal = 10;
      applications = 10;
      desktop = 10;
      popups = 10;
    };
    cursor = {
      package = pkgs.capitaine-cursors-themed;
      name = "Capitaine Cursors (Palenight)";
      size = 1;
    };
  };
}
