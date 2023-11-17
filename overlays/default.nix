# This file defines overlays
{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs {pkgs = final;};

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    base16-schemes = prev.base16-schemes.overrideAttrs (prev: {
      version = "git";
      src = final.pkgs.fetchFromGitHub {
        owner = "tinted-theming";
        repo = "base16-schemes";
        rev = "a9112eaae86d9dd8ee6bb9445b664fba2f94037a";
        sha256 = "sha256-5yIHgDTPjoX/3oDEfLSQ0eJZdFL1SaCfb9d6M0RmOTM=";
      };
    });
    nushell = prev.nushell.overrideAttrs (self: {
      doCheck = false;
      buildFeatures =
        self.buildFeatures
        or []
        ++ [
          "which-support"
          "zip"
          "sqlite"
          "dataframe"
          "extra"
        ];
    });
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  stable-packages = final: _prev: {
    stable = import inputs.stable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
