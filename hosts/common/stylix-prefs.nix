{pkgs, ...}: {
  stylix = let
    palette = ./themes/seqoia.yml;
  in {
    base16Scheme = palette;
    image = (import ../common/stylix.nix {inherit pkgs;}).processWallpaper palette 90 ../felys/wallpaper.png;
    opacity = {
      applications = 0.8;
      desktop = 0.85;
      terminal = 0.8;
    };
    fonts.sizes = {
      terminal = 10;
    };
    cursor = {
      package = pkgs.capitaine-cursors;
      name = "capitaine-cursors";
    };
  };
}
