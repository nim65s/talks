{
  lib,
  stdenvNoCC,

  yarn-berry_4,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  name = "talks-css";

  src = lib.fileset.toSource {
    root = ../.;
    fileset = lib.fileset.unions [
      ../Makefile
      ../package.json
      ../style.css
      ../template.html
      ../yarn.lock
    ];
  };

  missingHashes = ./missing-hashes.json;
  offlineCache = yarn-berry_4.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes;
    inherit (lib.importJSON ./lock-hash.json) hash;
  };

  makeFlags = [
    "PREFIX=$(out)"
    "css"
  ];

  nativeBuildInputs = [
    yarn-berry_4
    yarn-berry_4.yarnBerryConfigHook
  ];

  meta = {
    description = "CSS for my talks;";
    homepage = "https://github.com/nim65s/talks";
    license = lib.licenses.cc-by-sa-40;
    maintainers = [ lib.maintainers.nim65s ];
  };
})
