{pkgs ? (import ../nixpkgs.nix) {}}: {
  # mutableai-cli = pkgs.callPackage ((import ./default.nix).mutableai-cli {}) {};
}
