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
  "slskd-env.age".publicKeys = [
    pubkey
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO5vDL6bMkJlWMyDb8CK2gu1p1D/CPISSsuZhIHhxLKA root@muse"
  ];
}
