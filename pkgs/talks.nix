{
  lib,
  talks-css,
  talks-html,
  talks-pdfs,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation {
  name = "talks";

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
    talks-css
    talks-html
    talks-pdfs
  ];

  buildPhase = ''
    runHook preBuild

    mkdir -p public
    cp ${talks-css}/* public
    cp ${talks-pdfs}/* public
    cp ${talks-html}/* public

    runHook postBuild
  '';

  meta = {
    description = "my talks;";
    homepage = "https://github.com/nim65s/talks";
    license = lib.licenses.cc-by-sa-40;
    maintainers = [ lib.maintainers.nim65s ];
  };
}
