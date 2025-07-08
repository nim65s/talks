{
  lib,
  nim65s-talks-css,
  nim65s-talks-html,
  nim65s-talks-pdfs,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation {
  name = "nim65s-talks";

  src = lib.fileset.toSource {
    root = ../.;
    fileset = lib.fileset.unions [
      ../Makefile
    ];
  };

  makeFlags = [
    "PREFIX=$(out)"
  ];

  buildInputs = [
    nim65s-talks-css
    nim65s-talks-html
    nim65s-talks-pdfs
  ];

  buildPhase = ''
    runHook preBuild

    mkdir -p public
    cp ${nim65s-talks-css}/* public
    cp ${nim65s-talks-pdfs}/* public
    cp ${nim65s-talks-html}/* public

    runHook postBuild
  '';

  meta = {
    description = "my talks;";
    homepage = "https://github.com/nim65s/talks";
    license = lib.licenses.cc-by-sa-40;
    maintainers = [ lib.maintainers.nim65s ];
  };
}
