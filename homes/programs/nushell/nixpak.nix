{pkgs, ...}: let
  nushell = pkgs.nixpaked.nushellFull;

  home' = sloth: x: (sloth.concat' sloth.homeDir x);

  nushellBase = {sloth, ...}: let
    home = home' sloth;
  in {
    bubblewrap = {
      bind = {
        rw = [
          (sloth.mkdir "/tmp")
        ];
        ro = [
          (home "/.config/nushell/config.nu")
          (home "/.config/nushell/env.nu")
          (home "/.config/carapace/specs")
          (home "/.config/carapace/bin")
          (home "/.config/zsh/plugins/zsh-nix-shell")
          (home "/.cache/carapace")
          (home "/.cache/zoxide")
          (home "/.cache/starship")

          # PATH stuff
          (home "/.nix-profile")
          (home "/.local/share/flatpak/exports/bin")
          (home "/.local/state/nix/profile/bin")
          "/run/wrappers/bin"
          "/nix/profile/bin"
          # TODO: more granular access
          "/etc/profiles"
          "/nix/var/nix/profiles/default/bin"
          "/run/current-system/sw/bin"

          "/etc/nix/nix.conf"
        ];
      };
      env = {
        PATH = sloth.env "PATH";
      };
    };
  };

  # the "root" shell used to enter a specific project
  rootShell =
    nushell
    ({sloth, ...}: {
      imports = [nushellBase];
      bubblewrap = {
        bind = let
          home = home' sloth;
        in {
          rw = [
            (home "/projects")
            (home "/.config/nushell/history.txt")
          ];
        };
        env = {
          PATH = sloth.env "PATH";
        };
      };
    });

  # the "dev" shell used to enter a project. once a project is entered, it is bound to that project and should not be able to escape.
  devShell =
    nushell
    ({sloth, ...}: {
      imports = [nushellBase];

      bubblewrap = let
        extraArgsScript = pkgs.writeScript "extraArgs.sh" ''
          #!/usr/bin/env bash
          for arg in "$@"; do
            echo "$arg"
          done
          touch $HOME/.config/nushell/hist/$PROJECT_HIST
          echo "--bind-try"
          echo "$HOME/.config/nushell/hist/$PROJECT_HIST"
          echo "$HOME/.config/nushell/history.txt"
        '';
      in {
        extraArgsScript = "${extraArgsScript}";
        bind = {
          rw = [
            (sloth.env "PROJECT_PATH")
          ];
        };
      };
    });
in {
  inherit rootShell devShell;

  # script to bind to a project folder and enter the devShell
  enterScript = ''
    def enter_project [p: path] {
    	let p = $p | path expand
    	let hist_path = $"($p | str snake-case).txt"
      cd $p
    	PROJECT_PATH=$p PROJECT_HIST=$hist_path ${devShell}/bin/nu
    }
  '';
}
