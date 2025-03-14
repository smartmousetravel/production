{
  pkgs,
  pkgs-unstable,
  pyproject-build-systems,
  pyproject-nix,
  uv2nix,
}:
{
  default = pkgs.mkShell {
    nativeBuildInputs = [
      pkgs.google-cloud-sdk
      pkgs-unstable.terraform
    ];

    shellHook = ''
      if [ -e ./assets/gcp_credentials.json ]; then
        export GOOGLE_APPLICATION_CREDENTIALS=$(realpath ./assets/gcp_credentials.json)
        echo "Setting GOOGLE_APPLICATION_CREDENTIALS to $GOOGLE_APPLICATION_CREDENTIALS"
      fi
    '';
  };

  python-wp-plugin-info =
    let
      python = pkgs.python312;
      workspace = uv2nix.lib.workspace.loadWorkspace { workspaceRoot = ../pkgs/wp_plugin_info; };
      overlay = workspace.mkPyprojectOverlay { sourcePreference = "wheel"; };

      pythonSet =
        (pkgs.callPackage pyproject-nix.build.packages {
          inherit python;
        }).overrideScope
          (
            pkgs.lib.composeManyExtensions [
              pyproject-build-systems.overlays.default
              overlay
            ]
          );

      editablePythonSet = pythonSet.overrideScope (
        pkgs.lib.composeManyExtensions [
          (workspace.mkEditablePyprojectOverlay {
            root = "$REPO_ROOT/pkgs/wp_plugin_info";
          })
        ]
      );

      pythonEnv = editablePythonSet.mkVirtualEnv "wp-plugin-info-dev-env" workspace.deps.all;

    in
    pkgs.mkShell {
      packages = [
        pkgs.uv
        pythonEnv
      ];

      env = {
        UV_PYTHON_DOWNLOADS = "never";
        UV_NO_SYNC = "1"; # Don't create venvs with uv
        UV_PYTHON = "${pythonEnv}/bin/python";
      };

      shellHook = ''
        unset PYTHONPATH
        export REPO_ROOT=$(git rev-parse --show-toplevel)
      '';
    };
}
