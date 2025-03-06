{
  description = "The Smart Mouse Travel site in production";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    terranix = {
      url = "github:terranix/terranix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      flake-utils,
      terranix,
      treefmt-nix,
      ...
    }@inputs:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        pkgs-unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true; # the new Terraform license :(
        };
        treefmt = treefmt-nix.lib.evalModule pkgs ./nix/treefmt.nix;
      in
      {
        formatter = treefmt.config.build.wrapper;

        # Run 'nix run .#terraform-plan' etc for cloud asset deployment
        apps = import ./nix/terraform-apps.nix {
          inherit pkgs terranix;
          terraform = pkgs-unstable.terraform;
        };

        # Running 'nix develop' opens a development shell
        devShells = import ./nix/shell.nix { inherit pkgs pkgs-unstable; };
      }
    )
    // {
      nixosConfigurations = {
        buckbeak = nixpkgs.lib.nixosSystem {
          modules = [ ./nixos/hosts/buckbeak ];
          specialArgs = { inherit inputs; };
        };
      };
    };
}
