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
  };
}
