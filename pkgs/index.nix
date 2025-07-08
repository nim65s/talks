{
  lib,
  python3Packages,
  callPackage,
  uv2nix,
  pyproject-nix,
  pyproject-build-systems,
}:
let
  workspace = uv2nix.lib.workspace.loadWorkspace { workspaceRoot = ../.; };
  overlay = workspace.mkPyprojectOverlay { sourcePreference = "wheel"; };
  pythonSet =
    (callPackage pyproject-nix.build.packages { inherit (python3Packages) python; }).overrideScope
      (
        lib.composeManyExtensions [
          pyproject-build-systems.overlays.default
          overlay
          (_final: prev: {
            nim65s-talks-index = prev.nim65s-talks-index.overrideAttrs (super: {
              src = lib.fileset.toSource {
                root = super.src;
                fileset = lib.fileset.unions [
                  ../pyproject.toml
                  ../README.md
                  ../nim65s_talks_index.py
                  ../uv.lock
                ];
              };
            });
          })
        ]
      );
  virtualenv = editablePythonSet.mkVirtualEnv "nim65s-talks-index-dev-env" workspace.deps.all;
  editableOverlay = workspace.mkEditablePyprojectOverlay { root = "$REPO_ROOT"; };
  editablePythonSet = pythonSet.overrideScope (
    lib.composeManyExtensions [
      editableOverlay
      (final: prev: {
        nim65s-talks-index = prev.nim65s-talks-index.overrideAttrs (super: {
          nativeBuildInputs = super.nativeBuildInputs ++ final.resolveBuildSystem { editables = [ ]; };
        });
      })
    ]
  );
  editableVirtualenv = editablePythonSet.mkVirtualEnv "nim65s-talks-index-editable-dev-env" workspace.deps.all;
in
pythonSet.nim65s-talks-index
// {
  passthru = {
    inherit editableVirtualenv virtualenv;
  };
}
