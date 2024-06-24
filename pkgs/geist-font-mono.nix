{ lib
, stdenvNoCC
, unzip
}:
stdenvNoCC.mkDerivation {
  pname = "geist-font-mono";
  version = "1.0.0";

  src = ./Geist_Mono_Code.zip;

	sourceRoot = ".";

  postInstall = ''
    install -Dm444 *.otf -t $out/share/fonts/opentype
  '';

	nativeBuildInputs = [ unzip ];

  meta = {
    description = "Font family created by Vercel in collaboration with Basement Studio";
    homepage = "https://vercel.com/font";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ eclairevoyant ];
    platforms = lib.platforms.all;
  };
}
