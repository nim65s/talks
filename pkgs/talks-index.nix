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
            talks-index = prev.talks-index.overrideAttrs (super: {
              src = lib.fileset.toSource {
                root = super.src;
                fileset = lib.fileset.unions [
                  ../pyproject.toml
                  ../README.md
                  ../src/talks_index/__init__.py
                  ../uv.lock
                ];
              };
            });
          })
        ]
      );
  virtualenv = editablePythonSet.mkVirtualEnv "talks-index-dev-env" workspace.deps.all;
  editableOverlay = workspace.mkEditablePyprojectOverlay { root = "$REPO_ROOT"; };
  editablePythonSet = pythonSet.overrideScope (
    lib.composeManyExtensions [
      editableOverlay
      (final: prev: {
        talks-index = prev.talks-index.overrideAttrs (super: {
          nativeBuildInputs = super.nativeBuildInputs ++ final.resolveBuildSystem { editables = [ ]; };
        });
      })
    ]
  );
  editableVirtualenv = editablePythonSet.mkVirtualEnv "talks-index-editable-dev-env" workspace.deps.all;
in
pythonSet.talks-index
// {
  passthru = {
    inherit editableVirtualenv virtualenv;
  };
}
