{
  pkgs,
  config,
  ...
}: {
  programs.nushell = {
    enable = true;
    package = pkgs.nushell;
    shellAliases = let
      include = [
        "nosrs"
        "nosrt"
        "nosrb"
        "g"
        "ngc"
        "ngcdo"
        "cfg"
        "nvcfg"
        "top"
        "nf"
        "stl"
        "ctl"
        "ssh"
        "du"
      ];
    in
      pkgs.lib.filterAttrs (name: value: builtins.elem name include) config.home.shellAliases;
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
      use ${nu_scripts}/custom-completions/bitwarden-cli/bitwarden-cli-completions.nu *
      use ${nu_scripts}/custom-completions/btm/btm-completions.nu *
      use ${nu_scripts}/custom-completions/cargo/cargo-completions.nu *
      use ${nu_scripts}/custom-completions/git/git-completions.nu *
      use ${nu_scripts}/custom-completions/glow/glow-completions.nu *
      use ${nu_scripts}/custom-completions/just/just-completions.nu *
      use ${nu_scripts}/custom-completions/make/make-completions.nu *
      # use ${nu_scripts}/custom-completions/man/man-completions.nu *
      use ${nu_scripts}/custom-completions/nano/nano-completions.nu *
      use ${nu_scripts}/custom-completions/nix/nix-completions.nu *
      use ${nu_scripts}/custom-completions/npm/npm-completions.nu *
      use ${nu_scripts}/custom-completions/poetry/poetry-completions.nu *
      use ${nu_scripts}/custom-completions/tealdeer/tldr-completions.nu *
      use ${nu_scripts}/custom-completions/yarn/yarn-completion.nu *
      use ${nu_scripts}/custom-completions/zellij/zellij-completions.nu *
      use ${nu_scripts}/modules/nix/nix.nu *
      # use ${nu_scripts}/modules/network/sockets/sockets.nu
    '';
    extraEnv = ''
      $env.HOME = '${config.home.homeDirectory}'
      $env.HISTFILE = '${config.home.homeDirectory}/.local/share/nushell/history'
    '';
    # environmentVariables = builtins.mapAttrs (name: value: "\"${builtins.toString value}\"") config.home.sessionVariables;
  };
}
