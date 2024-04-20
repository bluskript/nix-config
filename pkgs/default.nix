{
  inputs,
  pkgs ? (import ../nixpkgs.nix) {},
  ...
} @ args: let
  node-packages = pkgs.callPackage (import ./node-packages/default.nix) {};
in {
  feishin = pkgs.callPackage (import ./feishin.nix) {};
  delfin = pkgs.callPackage (import ./delfin.nix) {};
  xornet-reporter = pkgs.callPackage (import ./xornet-reporter.nix) {};
  geist-font-sans = pkgs.callPackage (import ./geist-font-sans.nix) {};
  geist-font-mono = pkgs.callPackage (import ./geist-font-mono.nix) {};
  unocss-language-server = node-packages."unocss-language-server-git+https://git@github.com/rogersanctus/unocss-language-server#main";
  nixpaked = builtins.mapAttrs (k: v: a: (v a).config.env) ((import ./nixpak/default.nix) args);
  kagi-cli = inputs.kagi-cli.packages.${pkgs.system}.kagi-cli-release;
}
