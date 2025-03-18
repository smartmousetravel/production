{ pkgs, ... }:
pkgs.stdenv.mkDerivation {
  name = "astra-smt";
  version = "0.1.0";
  src = ./.;
  buildInputs = [ pkgs.terser ];

  buildPhase = ''
    runHook preBuild

    mkdir -p $out
    terser --compress --mangle --output $out/youtube.min.js youtube.js

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -pr assets $out/
    cp -p functions.php style.css youtube.css $out/

    runHook postInstall
  '';
}
