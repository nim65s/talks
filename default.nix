{
  breakpointHook,
  laas-beamer-theme,
  lib,
  nix-gitignore,
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

  src = nix-gitignore.gitignoreSource [ ./.nixignore ] ./.;

  makeFlags = "-j";

  nativeBuildInputs = [
    breakpointHook
    source-code-pro
    source-sans
    source-serif
  ];

  buildInputs = [
    pandoc
    (python3.withPackages (p: [ p.pyyaml ]))
    (texlive.combined.scheme-full.withPackages(_: [ laas-beamer-theme ]))
  ];

  preBuild = ''
    export XDG_CACHE_HOME="$(mktemp -d)"
  '';

  installPhase = ''
    mkdir $out
    cp public/*.{pdf,html} $out
  '';

  meta = {
    description = "my talks;";
    homepage = "https://github.com/nim65s/talks";
    license = lib.licenses.cc-by-sa-40;
    maintainers = [ lib.maintainers.nim65s ];
  };
}
