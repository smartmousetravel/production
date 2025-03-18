{
  description = "The Smart Mouse Travel site in production";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    pyproject-nix = {
      url = "github:pyproject-nix/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    uv2nix = {
      url = "github:pyproject-nix/uv2nix";
      inputs.pyproject-nix.follows = "pyproject-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pyproject-build-systems = {
      url = "github:pyproject-nix/build-system-pkgs";
      inputs.pyproject-nix.follows = "pyproject-nix";
      inputs.uv2nix.follows = "uv2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    terranix = {
      url = "github:terranix/terranix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      flake-utils,
      pyproject-build-systems,
      pyproject-nix,
      terranix,
      treefmt-nix,
      uv2nix,
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
        packages = import ./pkgs { inherit pkgs; };

        formatter = treefmt.config.build.wrapper;

        # Run 'nix run .#terraform-plan' etc for cloud asset deployment
        apps = import ./nix/terraform-apps.nix {
          inherit pkgs terranix;
          terraform = pkgs-unstable.terraform;
        };

        # Running 'nix develop' opens a development shell
        devShells = import ./nix/shell.nix {
          inherit
            pkgs
            pkgs-unstable
            pyproject-build-systems
            pyproject-nix
            uv2nix
            ;
        };
      }
    )
    // {
      nixosConfigurations = {
        buckbeak = nixpkgs.lib.nixosSystem {
          modules = [ ./nixos/hosts/buckbeak ];
          specialArgs = {
            inherit inputs;
            pkgs-smt = self.outputs.packages.x86_64-linux;
          };
        };
      };
    };
}
