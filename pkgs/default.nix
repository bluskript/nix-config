{pkgs ? (import ../nixpkgs.nix) {}}: {
	xornet-reporter = pkgs.callPackage (import ./xornet-reporter.nix) {};
	geist-font-sans = pkgs.callPackage (import ./geist-font-sans.nix) {};
	geist-font-mono = pkgs.callPackage (import ./geist-font-mono.nix) {};
  # mutableai-cli = pkgs.callPackage ((import ./default.nix).mutableai-cli {}) {};
}
