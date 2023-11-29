let
  pubkey = (import ../identities/blusk.nix).pubkey;
in {
  "firefox-syncserver.age".publicKeys = [
    pubkey
  ];
  "felys-xornet.age".publicKeys = [
    pubkey
  ];
  "nozomi-xornet.age".publicKeys = [
    pubkey
  ];
  "rathole-server.age".publicKeys = [
    pubkey
  ];
  "rathole-muse-client.age".publicKeys = [
    pubkey
  ];
}
