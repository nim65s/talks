{
  lib,
  stdenvNoCC,

  tailwindcss_4,
  yarn-berry_4,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  name = "nim65s-talks-css";

  src = lib.fileset.toSource {
    root = ../.;
    fileset = lib.fileset.unions [
      ../Makefile
      ../package.json
      ../style.css
      ../tailwind.config.js
      ../template.html
      ../yarn.lock
    ];
  };

  offlineCache = yarn-berry_4.fetchYarnBerryDeps {
    inherit (finalAttrs) src;
    hash = "sha256-fKxxacf1ONsr0SeHeAQwVe6fToJ40nFsjONYh5zQ8Cw=";
  };

  makeFlags = [
    "PREFIX=$(out)"
    "css"
  ];

  nativeBuildInputs = [
    tailwindcss_4
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
