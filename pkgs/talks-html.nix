{
  lib,
  stdenvNoCC,

  talks-index,
  yarn-berry_4,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  name = "talks-html";
  version = "2.0.1";

  src = lib.fileset.toSource {
    root = ../.;
    fileset = lib.fileset.unions [
      (lib.fileset.fileFilter (file: file.hasExt "md") ../talks)
      ../icons.js
      ../package.json
      ../src/talks_index/__init__.py
      ../Makefile
      ../template.html
      ../yarn.lock
    ];
  };

  missingHashes = ./missing-hashes.json;
  offlineCache = yarn-berry_4.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes;
    inherit (lib.importJSON ./lock-hash.json) hash;
  };

  env.PYTHONPATH = "src";

  makeFlags = [
    "PREFIX=$(out)"
    "html"
  ];

  nativeBuildInputs = [
    talks-index.passthru.virtualenv
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
