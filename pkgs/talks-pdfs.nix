{
  breakpointHook,
  laas-beamer-theme,
  lib,
  pandoc,
  source-code-pro,
  source-sans,
  source-serif,
  stdenvNoCC,
  texlive,
  writableTmpDirAsHomeHook,
}:
stdenvNoCC.mkDerivation {
  name = "talks-pdfs";
  version = "2.0.2";

  src = lib.fileset.toSource {
    root = ../.;
    fileset = lib.fileset.unions [
      (lib.fileset.fileFilter (file: file.hasExt "md") ../talks)
      ../Makefile
      ../media
      ../references.bib
    ];
  };

  makeFlags = [
    "PREFIX=$(out)"
    "pdfs"
    "-j"
  ];

  nativeBuildInputs = [
    breakpointHook
    writableTmpDirAsHomeHook
    pandoc
    source-code-pro
    source-sans
    source-serif
    (texlive.combined.scheme-full.withPackages (_: [ laas-beamer-theme ]))
  ];

  meta = {
    description = "PDFs of my talks;";
    homepage = "https://github.com/nim65s/talks";
    license = lib.licenses.cc-by-sa-40;
    maintainers = [ lib.maintainers.nim65s ];
  };
}
