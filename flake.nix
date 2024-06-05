{
  description = "Mia's nix config";


  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixinate = {
      url = "github:matthewcroughan/nixinate";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hardware.url = "github:nixos/nixos-hardware";
    impermanence.url = "github:nix-community/impermanence";

    stylix.url = "github:bluskript/stylix/myfork";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    blusk-repo.url = "github:bluskript/nix-repo";
    nixos-vfio.url = "github:bluskript/nixos-vfio";

    swayfx.url = "github:WillPower3309/swayfx";
    swayfx.inputs.nixpkgs.follows = "nixpkgs";

    nix-gaming.url = "github:fufexan/nix-gaming";

    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";

    flake-compat = {
      url = "github:inclyc/flake-compat";
      flake = false;
    };

    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    discordrp-mpris.url = "github:bluskript/discordrp-mpris-flake";
    discordrp-mpris.inputs.nixpkgs.follows = "nixpkgs";

    firefox.url = "github:nix-community/flake-firefox-nightly?rev=57df49781ef1b803e9b8f39509d32f864824df87";

    deploy-rs.url = "github:serokell/deploy-rs";

    microvm = {
      url = "github:astro/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpak = {
      url = "github:bluskript/nixpak/work/blusk/extra-args-script";
      # url = "/home/blusk/projects/contrib/nixpak";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpak-pkgs = {
      url = "github:nixpak/pkgs";
      inputs.nixpak.follows = "nixpak";
    };

    kagi-cli.url = "git+ssh://git@github.com/bluskript/kagi-cli.git";
    nix-inspect.url = "github:bluskript/nix-inspect";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    disko,
    nix-index-database,
    agenix,
    deploy-rs,
    microvm,
    ...
  } @ inputs: let
    inherit (self) outputs;
    forAllSystems = nixpkgs.lib.genAttrs [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
  in {
    # Your custom packages
    # Acessible through 'nix build', 'nix shell', etc
    packages = forAllSystems (
      system: let
        overlays = import ./overlays {inherit inputs;};
        pkgs = import nixpkgs {
          inherit system;
          overlays = [overlays.additions overlays.modifications];
        };
      in
        import ./pkgs {inherit pkgs inputs system;}
    );
    # Devshell for bootstrapping
    # Acessible through 'nix develop' or 'nix-shell' (legacy)
    devShells = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        import ./shell.nix {inherit pkgs;}
    );

    # Your custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};
    # Reusable nixos modules you might want to export
    # These are usually stuff you would upstream into nixpkgs
    nixosModules = import ./modules/nixos;
    # Reusable home-manager modules you might want to export
    # These are usually stuff you would upstream into home-manager
    homeManagerModules = import ./modules/home-manager;

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      NoAH-II = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          outputs.nixosModules.xornet-reporter
          inputs.stylix.nixosModules.stylix
          inputs.nixos-vfio.nixosModules.kvmfr
          inputs.nixos-vfio.nixosModules.vfio
          agenix.nixosModules.default
          (import ./hosts/noah_ii/configuration.nix)
        ];
      };
      felys = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          outputs.nixosModules.xornet-reporter
          inputs.stylix.nixosModules.stylix
          inputs.nixos-vfio.nixosModules.kvmfr
          inputs.nixos-vfio.nixosModules.vfio
          disko.nixosModules.disko
          agenix.nixosModules.default
          (import ./hosts/felys/configuration.nix)
          {
            environment.systemPackages = [agenix.packages.x86_64-linux.default];
          }
        ];
      };
      nozomi = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          outputs.nixosModules.xornet-reporter
          agenix.nixosModules.default
          (import ./hosts/nozomi/configuration.nix)
          disko.nixosModules.disko
        ];
      };
      muse = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          outputs.nixosModules.xornet-reporter
          agenix.nixosModules.default
          (import ./hosts/muse/configuration.nix)
          disko.nixosModules.disko
        ];
      };
    };

    deploy = {
      magicRollback = false;
      autoRollback = false;
      nodes.muse = {
        hostname = "10.9.1.12";
        profiles.system = {
          sshUser = "blusk";
          user = "root";
          fastConnection = true;
          path =
            deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.muse;
        };
      };
    };
    #
    # # This is highly advised, and will prevent many possible mistakes
    # checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
  };
}
