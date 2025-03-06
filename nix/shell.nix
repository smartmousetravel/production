{
  pkgs,
  pkgs-unstable,
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
}
