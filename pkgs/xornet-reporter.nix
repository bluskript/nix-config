{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
  cmake,
  perl
}:
rustPlatform.buildRustPackage {
  pname = "xornet-reporter";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "otiskujawa";
    repo = "Reporter";
    rev = "f15eacfc7778b88e00e6fb597eb2e7cba0ec4c0f";
    hash = "sha256-3OSi4fk65jqtornvHkjUD9/N+5U5ZRB/SP99Re3Hg9E=";
  };

  cargoHash = "sha256-o4CWyxzCJwfM1fVCaRb5FfHEPB7Lt66Z93N9aeh26AY=";

  nativeBuildInputs = [ cmake pkg-config perl ];
  buildInputs = [ openssl ];

  meta = with lib; {
    description = "This is the data collector that gets your system's state and sends it to the backend.";
    homepage = "https://github.com/otiskujawa/Reporter";
    license = with licenses; [gpl3];
    maintainers = with maintainers; [blusk];
    broken = stdenv.isDarwin;
  };
}
