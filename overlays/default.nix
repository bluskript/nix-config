{inputs, ...}: {
  additions = final: _prev:
    import ../pkgs {
      pkgs = final;
      inputs = inputs;
    };

  modifications = final: prev: {
    jellyfin = prev.jellyfin.overrideAttrs (self: {
      patches =
        (self.patches or [])
        ++ [
          ./patches/playlist-fix.patch
        ];
    });

    # imv has a regression with image pipes, this fixes it
    imv = (builtins.getFlake "github:NixOS/nixpkgs?rev=aeca39024902034d198ac955cab5196b3729511c").outputs.legacyPackages.${prev.system}.imv;

    base16-schemes = prev.base16-schemes.overrideAttrs (prev: {
      version = "git";
      src = final.pkgs.fetchFromGitHub {
        owner = "tinted-theming";
        repo = "base16-schemes";
        rev = "a9112eaae86d9dd8ee6bb9445b664fba2f94037a";
        sha256 = "sha256-5yIHgDTPjoX/3oDEfLSQ0eJZdFL1SaCfb9d6M0RmOTM=";
      };
    });
    firefox-hardenedsupport = prev.firefox-devedition.unwrapped;
    # firefox-hardenedsupport = prev.wrapFirefox (prev.firefox-devedition.unwrapped.override {
    #   jemallocSupport = false;
    # }) {};
    libvirt = prev.libvirt.overrideAttrs (prev: {
      patches =
        (prev.patches or [])
        ++ [
          ./patches/0003-substitute-modules-path.patch
        ];
    });
  };
}
