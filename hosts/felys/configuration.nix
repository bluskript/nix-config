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
    ../common/wayfire.nix
    ../felys/impermanence.nix
    ../felys/users.nix
    ./passthrough.nix
    ./disks.nix
    ./bluetooth.nix
    # ./microvm.nix

    ./hidden.nix
  ];

  age.secrets.xornet.file = ../../secrets/felys-xornet.age;
  age.identityPaths = ["/home/blusk/.ssh/id_ed25519"];

  work-mode.enable = false;

  # services.stalwart-mail = {
  #   enable = true;
  #   configFile = ../nozomi/mail.toml;
  # };

  networking.hostName = "felys";
  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";

  hardware.pulseaudio.enable = false;

  services.hardware.openrgb = {
    enable = true;
    motherboard = "amd";
  };

  # systemd.services.post-suspend-actions = {
  #   description = "Restore openrgb profile";
  #   environment.WAYLAND_DISPLAY = "wayland-1";
  #   environment.XDG_RUNTIME_DIR = "/run/user/1000";
  #   wantedBy = ["multi-user.target" "suspend.target"];
  #   serviceConfig = {
  #     Type = "forking";
  #     User = "blusk";
  #     ExecStart = "${pkgs.openrgb}/bin/openrgb -p main.orp";
  #   };
  # };

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
