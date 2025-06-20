{
  lib,
  nim65s-talks-index,
  nodePackages,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation {
  name = "nim65s-talks-html";

  src = lib.fileset.toSource {
    root = ../.;
    fileset = lib.fileset.unions [
      (lib.fileset.fileFilter (file: file.hasExt "md") ../talks)
      ../nim65s_talks_index.py
      ../Makefile
      ../public
      ../style.css
      ../tailwind.config.js
      ../template.html
    ];
  };

  env.PYTHONPATH = ".";

  makeFlags = [
    "-j"
    "html"
  ];

  nativeBuildInputs = [
    nodePackages.tailwindcss
    nim65s-talks-index.passthru.virtualenv
  ];

  installPhase = ''
    runHook preInstall

    install -Dm 644 public/* -t $out

    runHook postInstall
  '';

  meta = {
    description = "HTML index of my talks;";
    homepage = "https://github.com/nim65s/talks";
    license = lib.licenses.cc-by-sa-40;
    maintainers = [ lib.maintainers.nim65s ];
  };
}
