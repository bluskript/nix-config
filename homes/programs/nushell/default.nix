{
  pkgs,
  config,
  ...
}: let
  nixpakedNushell = (import ./nixpak.nix) { inherit pkgs; };
in {
  programs.nushell = {
    enable = true;
    package = pkgs.nushellFull;
    shellAliases = let
      include = [
        "nosrs"
        "nosrt"
        "nosrb"
        "g"
        "ngc"
        "ngcdo"
        "nvcfg"
        "top"
        "nf"
        "stl"
        "ctl"
        "du"
      ];
    in
      (pkgs.lib.filterAttrs (name: value: builtins.elem name include) config.home.shellAliases)
      // {
        cfg = "nvim /etc/nixos";
      };
    extraConfig = let
      nu_scripts = "${pkgs.nu_scripts}/share/nu_scripts";
    in ''
      # Translate text using Google Translate
      export def tl [
        text: string, # The text to translate
        --source(-s): string = "auto", # The source language
        --destination(-d): string = "fr", # The destination language
        --list(-l)  # Select destination language from list
      ] {

        mut dest = ""

        if $list {
          let languages = open ${./languages.json}
          let selection = (
            $languages
            | columns
            | input list -f (echo "Select destination language:")
          )

          $dest = ($languages | get $selection)

        } else {
            $dest = $destination
        }

        {
          scheme: "https",
          host: "translate.googleapis.com",
          path: "/translate_a/single",
          params: {
              client: gtx,
              sl: $source,
              tl: $dest,
              dt: t,
              q: ($text | url encode),
          }
        }
        | url join
        | http get $in
        | get 0.0.0
      }
      ${builtins.readFile ./config.nu}
      register ${pkgs.nushellPlugins.formats}/bin/nu_plugin_formats
      use ${nu_scripts}/modules/nix/nix.nu *
      # use ${nu_scripts}/modules/network/sockets/sockets.nu

      ${nixpakedNushell.enterScript}
    '';
    extraEnv = ''
      $env.HOME = '${config.home.homeDirectory}'
      $env.HISTFILE = '${config.home.homeDirectory}/.config/nushell/history'
    '';
    # environmentVariables = builtins.mapAttrs (name: value: "\"${builtins.toString value}\"") config.home.sessionVariables;
  };
}
