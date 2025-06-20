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
  name = "nim65s-talks-pdfs";

  src = lib.fileset.toSource {
    root = ../.;
    fileset = lib.fileset.unions [
      (lib.fileset.fileFilter (file: file.hasExt "md") ../talks)
      ../Makefile
      ../media
      ../public
      ../references.bib
    ];
  };

  makeFlags = [
    "-j"
    "pdfs"
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

  installPhase = ''
    runHook preInstall

    install -Dm 644 public/* -t $out

    runHook postInstall
  '';

  meta = {
    description = "PDFs of my talks;";
    homepage = "https://github.com/nim65s/talks";
    license = lib.licenses.cc-by-sa-40;
    maintainers = [ lib.maintainers.nim65s ];
  };
}
