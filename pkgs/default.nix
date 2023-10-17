{pkgs ? (import ../nixpkgs.nix) {}}: {
	xornet-reporter = pkgs.callPackage (import ./xornet-reporter.nix) {};
  # mutableai-cli = pkgs.callPackage ((import ./default.nix).mutableai-cli {}) {};
}
