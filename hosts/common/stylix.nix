{pkgs, ...}: {
  processWallpaper = let
    palette = let
      convert = "${pkgs.imagemagick}/bin/magick convert";
    in
      x:
        pkgs.runCommand "palette.png" {} ''
          colors=$(${pkgs.yq}/bin/yq -r '.base00, .base01, .base02, .base03, .base04, .base05, .base06, .base07, .base08, .base09, .base0A, .base0B, .base0C, .base0D, .base0E, .base0F' ${x})
          color_array=($colors)
          command="${convert} -size 10000x1"
          prev_color=""
          for color in $colors; do
            if [ -n "$prev_color" ]; then
              command+=" gradient:\"#$prev_color-#$color\""
            fi
            prev_color=$color
          done

          # generate gradients between the foreground colors and background colors
          for ((i=4;i<=15;i++)); do
            for ((j=7;j<=15;j++)); do
              if (( i != j )); then
                command+=" gradient:\"#''${color_array[i]}-#''${color_array[j]}\""
              fi
            done
          done
          command+=" +append $out"
          echo $command
          eval $command
        '';
  in (p: w:
    pkgs.runCommand "image.png" {} ''
      ${pkgs.imagemagick}/bin/magick convert ${w} -remap ${palette p} -dither FloydSteinberg -depth 8 -enhance $out
    '');
}
