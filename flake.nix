{
  description = "Mia's nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stable.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
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

    stylix.url = "/home/blusk/projects/contrib/stylix";
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

    llamacpp = {
      url = "github:ggerganov/llama.cpp";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    disko,
    nix-index-database,
    agenix,
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
  in rec {
    # Your custom packages
    # Acessible through 'nix build', 'nix shell', etc
    # packages = forAllSystems (system:
    #   let pkgs = nixpkgs.legacyPackages.${system};
    #   in import ./pkgs { inherit pkgs; }
    # );
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

    apps = inputs.nixinate.nixinate.x86_64-linux self;

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      NoAH-II = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
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
          inputs.stylix.nixosModules.stylix
          inputs.nixos-vfio.nixosModules.kvmfr
          inputs.nixos-vfio.nixosModules.vfio
          disko.nixosModules.disko
          agenix.nixosModules.default
          (import ./hosts/felys/configuration.nix)
        ];
      };
      nozomi = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          (import ./hosts/nozomi/configuration.nix)
          disko.nixosModules.disko
          {
            _module.args.nixinate = {
              host = "5.161.75.53";
              sshUser = "blusk";
              buildOn = "remote";
              substituteOnTarget = true;
              hermetic = false;
            };
          }
        ];
      };
    };

    packages.x86_64-linux = {
      nozomi-iso = inputs.nixos-generators.nixosGenerate {
        system = "x86_64-linux";
        modules = [
          ./hosts/nozomi/configuration.nix
        ];
        format = "iso";
      };
    };
  };
}
