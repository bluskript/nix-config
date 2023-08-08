{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager

    inputs.hardware.nixosModules.common-pc-laptop-ssd

    ../common/profiles/desktop.nix
    ../felys/impermanence.nix
    ../felys/users.nix
    ../noah_ii/firejail.nix
    ./passthrough.nix
    ./disks.nix
    ./bluetooth.nix

    ./hidden.nix
  ];

  networking.hostName = "felys";
  stylix = let
    theme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
    palette = let
      convert = "${pkgs.imagemagick}/bin/magick convert";
    in
      pkgs.runCommand "palette.png" {} ''
        colors=$(${pkgs.yq}/bin/yq -r '.base00, .base01, .base02, .base03, .base04, .base05, .base06, .base07, .base08, .base09, .base0A, .base0B, .base0C, .base0D, .base0E, .base0F' ${theme})
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
    wallpaper = pkgs.runCommand "image.png" {} ''
      ${pkgs.imagemagick}/bin/magick convert ${./wallpaper.png} -remap ${palette} -dither FloydSteinberg -depth 8 -enhance $out
    '';
  in {
    image = wallpaper;
    base16Scheme = theme;
    # stylix.base16Scheme = ../common/colors.yml;
  };
  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";

  services.hardware.openrgb = {
    enable = true;
    motherboard = "amd";
  };

  services.openssh.enable = true;
  services.openssh.allowSFTP = true;

  # vfio.enable = true;
  # specialisation."NOVFIO".configuration = {
  #   system.nixos.tags = [ "no-vfio" ];
  #   vfio.enable = lib.mkForce false;
  #   imports = [
  #     inputs.hardware.nixosModules.common-cpu-intel
  #     ../noah_ii/nvidia.nix
  #   ];
  # };

  services.journald.extraConfig = "Storage=persistent";

  services.mullvad-vpn.enable = true;

  programs.wireshark.enable = true;
  programs.wireshark.package = pkgs.wireshark;

  networking.firewall = {
    enable = true;
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      } # KDE Connect
    ];
    allowedUDPPortRanges = [
      {
        from = 1714;
        to = 1764;
      } # KDE Connect
    ];
  };

  programs.adb.enable = true;
  # for MTP
  services.gvfs.enable = true;

  home-manager = {
    extraSpecialArgs = {
      inherit inputs outputs;
      nixosConfig = config;
    };
    # useGlobalPkgs = true;
    # useUserPackages = true;
    users = {
      blusk = import ../../homes/blusk_workstation/home.nix;
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";
}
