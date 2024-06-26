{
  laas-beamer-theme,
  lib,
  nodePackages,
  pandoc,
  python3,
  source-code-pro,
  source-sans,
  source-serif,
  stdenvNoCC,
  texlive,
}:
stdenvNoCC.mkDerivation {
  name = "talks";

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      (lib.fileset.fileFilter (file: file.hasExt "md") ./talks)
      ./index.py
      ./Makefile
      ./media
      ./references.bib
      ./style.css
      ./tailwind.config.js
      ./template.html
    ];
  };

  makeFlags = "-j";

  nativeBuildInputs = [
    nodePackages.tailwindcss
    pandoc
    (python3.withPackages (p: [
      p.jinja2
      p.pyyaml
    ]))
    source-code-pro
    source-sans
    source-serif
    (texlive.combined.scheme-full.withPackages (_: [ laas-beamer-theme ]))
  ];

  preBuild = ''
    export XDG_CACHE_HOME="$(mktemp -d)"
  '';

  installPhase = "install -Dm 644 public/* -t $out";

  meta = {
    description = "my talks;";
    homepage = "https://github.com/nim65s/talks";
    license = lib.licenses.cc-by-sa-40;
    maintainers = [ lib.maintainers.nim65s ];
  };
}
