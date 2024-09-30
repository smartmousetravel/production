{
  description = "The Smart Mouse Travel site in production";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      flake-utils,
      nixpkgs,
      nixpkgs-unstable,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        pkgs-unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true; # the new Terraform license :(
        };
      in
      {
        formatter = pkgs-unstable.nixfmt-rfc-style;

        # Running 'nix develop' opens a development shell
        devShells = import ./shell.nix { inherit pkgs pkgs-unstable; };
      }
    );
}
