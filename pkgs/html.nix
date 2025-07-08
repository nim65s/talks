{
  lib,
  stdenvNoCC,

  nim65s-talks-index,
}:
stdenvNoCC.mkDerivation (_finalAttrs: {
  name = "nim65s-talks-html";

  src = lib.fileset.toSource {
    root = ../.;
    fileset = lib.fileset.unions [
      (lib.fileset.fileFilter (file: file.hasExt "md") ../talks)
      ../nim65s_talks_index.py
      ../Makefile
      ../template.html
    ];
  };

  env.PYTHONPATH = ".";

  makeFlags = [
    "PREFIX=$(out)"
    "html"
  ];

  nativeBuildInputs = [
    nim65s-talks-index.passthru.virtualenv
  ];

  meta = {
    description = "HTML index of my talks;";
    homepage = "https://github.com/nim65s/talks";
    license = lib.licenses.cc-by-sa-40;
    maintainers = [ lib.maintainers.nim65s ];
  };
})
