# Add your reusable NixOS modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
{
  # List your module files here
  # my-module = import ./my-module.nix;
  # qemu-guest = import ./qemu-guest.nix;
	xornet-reporter = import ./xornet-reporter.nix;
	rathole = import ./rathole.nix;
}
