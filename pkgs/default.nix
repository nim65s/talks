{
  lib,
  nim65s-talks-html,
  nim65s-talks-pdfs,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation {
  name = "nim65s-talks";

  src = lib.fileset.toSource {
    root = ../.;
    fileset = lib.fileset.unions [
      ../public
    ];
  };

  buildInputs = [
    nim65s-talks-html
    nim65s-talks-pdfs
  ];

  buildPhase = ''
    runHook preBuild

    cp ${nim65s-talks-pdfs}/* public
    cp ${nim65s-talks-html}/* public

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm 644 public/* -t $out

    runHook postBuild
  '';

  meta = {
    description = "my talks;";
    homepage = "https://github.com/nim65s/talks";
    license = lib.licenses.cc-by-sa-40;
    maintainers = [ lib.maintainers.nim65s ];
  };
}
