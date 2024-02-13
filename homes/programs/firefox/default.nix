{
  inputs,
  pkgs,
  ...
}: {
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-hardenedsupport;
    profiles = {
      dev-edition-default = {
        id = 0;
        extraConfig = builtins.readFile ./user.js;
        userChrome = builtins.readFile ./userChrome.css;
        settings = {
          "identity.sync.tokenserver.uri" = "https://firefox.blusk.dev/1.0/sync/1.5";
        };
        extensions = [
          # (
          #   pkgs.stdenv.mkDerivation {
          #     name = "bluskext";
          #     builder = pkgs.writeScript "compress-extension" ''
          #       source $stdenv/setup
          #       mkdir -p $out
          #       zip -r $out/bluskext.xpi ${./csp-fixes}
          #     '';
          #     nativeBuildInputs = with pkgs; [coreutils zip];
          #   }
          # )
        ];
      };
      Work = {
        id = 1;
      };
    };
  };
}
