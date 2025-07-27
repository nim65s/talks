{
  lib,
  stdenvNoCC,

  nim65s-talks-index,
  yarn-berry_4,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  name = "nim65s-talks-html";

  src = lib.fileset.toSource {
    root = ../.;
    fileset = lib.fileset.unions [
      (lib.fileset.fileFilter (file: file.hasExt "md") ../talks)
      ../icons.js
      ../package.json
      ../nim65s_talks_index.py
      ../Makefile
      ../template.html
      ../yarn.lock
    ];
  };

  offlineCache = yarn-berry_4.fetchYarnBerryDeps {
    inherit (finalAttrs) src;
    hash = "sha256-fKxxacf1ONsr0SeHeAQwVe6fToJ40nFsjONYh5zQ8Cw=";
  };

  env.PYTHONPATH = ".";

  makeFlags = [
    "PREFIX=$(out)"
    "html"
  ];

  nativeBuildInputs = [
    nim65s-talks-index.passthru.virtualenv
    yarn-berry_4
    yarn-berry_4.yarnBerryConfigHook
  ];

  meta = {
    description = "HTML index of my talks;";
    homepage = "https://github.com/nim65s/talks";
    license = lib.licenses.cc-by-sa-40;
    maintainers = [ lib.maintainers.nim65s ];
  };
})
