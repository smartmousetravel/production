{
  pkgs,
  pkgs-unstable,
}:
{
  default = pkgs.mkShell {
    NIX_CONFIG = "extra-experimental-features = nix-command flakes";

    nativeBuildInputs = [
      pkgs.google-cloud-sdk
      pkgs.jq
      pkgs.shfmt

      pkgs-unstable.terraform
    ];
  };
}
