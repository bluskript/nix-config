{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) fileContents mkIf;
  nixBin = "${config.nix.package}/bin/nix";
  pkgBin = pkg:
    if (pkg.meta or {}) ? mainProgram
    then "${pkg}/bin/${pkg.meta.mainProgram}"
    else "${pkg}/bin/${pkg.pname}";
in {
  users.mutableUsers = false;

  environment.systemPackages = with pkgs; [
    pciutils
    killall
    ripgrep
    skim
    bottom
    git
    jq
    curl
    fd
    du-dust
    coreutils
    binutils
    iputils
    moreutils
    fzf
    unzip
    zip
    util-linux
    ncdu
    tealdeer
  ];

  environment.shellAliases = let
    ifSudo = string: mkIf config.security.sudo.enable string;
    inherit (pkgs) git bat eza du-dust ranger;
  in {
    g = pkgBin git;
    git-optimize = "${pkgBin git} gc --aggressive --prune=now";
    cat = "${pkgBin bat} --theme=base16";
    c = "cat";
    du = "${pkgBin du-dust}";
    free = "${pkgs.procps}/bin/free -h";
    ls = pkgBin eza;
    l = "${pkgBin eza} -lhg";
    la = "${pkgBin eza} -lhg -a";
    t = "${pkgBin eza} -lhg -T";
    ta = "${pkgBin eza} -lhg -a -T";
    n = nixBin;
    nf = "${nixBin} flake";
    nfu = "${nixBin} flake update";
    nfui = "${nixBin} flake lock --update-input";
    nfs = "${nixBin} flake show";
    nsh = "${nixBin} shell";
    nix-store-refs = "nix-store -qR";
    cfg = "${pkgBin ranger} /etc/nixos";
    nosrs = ifSudo "sudo nixos-rebuild --fast switch";
    nosrb = ifSudo "sudo nixos-rebuild --fast boot";
    nosrt = ifSudo "sudo nixos-rebuild --fast test";
    ngc = ifSudo "sudo nix-collect-garbage";
    ngcdo = ifSudo "sudo nix-collect-garbage --delete-old";
    top = "${pkgs.bottom}/bin/btm";
    # systemd
    ctl = "systemctl";
    stl = ifSudo "s systemctl";
    utl = "systemctl --user";
    jtl = "journalctl";
    ssh = "TERM=xterm-256color ssh";
  };
}
