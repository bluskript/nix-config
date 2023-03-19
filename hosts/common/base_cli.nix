{ pkgs, config, lib, ... }: let
  inherit (lib) fileContents mkIf;
  nixBin = "${config.nix.package}/bin/nix";
  pkgBin = pkg:
    if (pkg.meta or {}) ? mainProgram
    then "${pkg}/bin/${pkg.meta.mainProgram}"
    else "${pkg}/bin/${pkg.pname}";
in {
  environment.systemPackages = with pkgs; [
    manix
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
  ];

  environment.shellAliases = let
      ifSudo = string: mkIf config.security.sudo.enable string;
      inherit (pkgs) git bat exa du-dust;
    in {
      g = pkgBin git;
      git-optimize = "${pkgBin git} gc --aggressive --prune=now";
      cat = "${pkgBin bat} --theme=base16";
      c = "cat";
      du = "${pkgBin du-dust}";
      free = "${pkgs.procps}/bin/free -h";
      ls = pkgBin exa;
      l = "${pkgBin exa} -lhg";
      la = "${pkgBin exa} -lhg -a";
      t = "${pkgBin exa} -lhg -T";
      ta = "${pkgBin exa} -lhg -a -T";
      n = nixBin;
      nf = "${nixBin} flake";
      nfu = "${nixBin} flake update";
      nfui = "${nixBin} flake lock --update-input";
      nfs = "${nixBin} flake show";
      nsh = "${nixBin} shell";
      nix-store-refs = "nix-store -qR";
      cfg = "ranger /etc/nixos";
      nosrs = ifSudo "sudo nixos-rebuild --fast switch";
      nosrb = ifSudo "sudo nixos-rebuild --fast boot";
      nosrt = ifSudo "sudo nixos-rebuild --fast test";
      ngc = ifSudo "sudo nix-collect-garbage";
      ngcdo = ifSudo "sudo nix-collect-garbage --delete-old";
      top = "${pkgs.bottom}/bin/btm";
      myip = "${pkgs.dnsutils}/bin/dig +short myip.opendns.com @208.67.222.222 2>&1";
      mn = let
        manix_preview = "manix '{}' | sed 's/type: /> type: /g' | bat -l Markdown --color=always --plain";
      in ''manix "" | rg '^# ' | sed 's/^# \(.*\) (.*/\1/;s/ (.*//;s/^# //' | sk --preview="${manix_preview}" | xargs manix'';
      # systemd
      ctl = "systemctl";
      stl = ifSudo "s systemctl";
      utl = "systemctl --user";
      jtl = "journalctl";
    };
}
