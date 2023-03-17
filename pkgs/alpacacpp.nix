{ lib, stdenv, fetchgit, fetchurl }:

stdenv.mkDerivation rec {
  pname = "alpacacpp";
  version = "0.1.0";
  src = fetchgit {
    url = "https://github.com/antimatter15/alpaca.cpp";
    sha256 = "sha256-v1dCstLcVgRn/Rd2My5nfBM8PzoSfpsjbiTPIvKOQSI=";
  };
  weights = fetchurl {
    url = "https://cloudflare-ipfs.com/ipfs/QmQ1bf2BTnYxq73MFJWu1B7bQ2UD6qG7D7YDCxhTndVkPC";
    sha256 = "0000000000000000000000000000000000000000000000000000";
  };
  buildPhase = ''
    ln -s ${weights} ./ggml-alpaca-7b-q4.bin
    make chat
  '';
  installPhase = ''
    mkdir -p $out/bin
    mv chat $out/bin/alpaca-chat
  '';
}
