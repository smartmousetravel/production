{ pkgs, ... }:
{
  projectRootFile = "flake.nix";
  programs = {
    buildifier = {
      enable = true;
      includes = [
        "*.bazel"
        "*.bzl"
        "WORKSPACE"
      ];
    };
    nixfmt.enable = true;
    prettier.enable = true;
    terraform.enable = true;
  };

  settings.global.excludes = [
    ".editorconfig"
    ".envrc"
    ".prettierignore"
    "*.gitignore"
    "*.lock.hcl"
    "pkgs/astra-smt/COPYING"
    "pkgs/astra-smt/assets/play.png"
    "pkgs/astra-smt/functions.php"
    "servers/*"
  ];
}
