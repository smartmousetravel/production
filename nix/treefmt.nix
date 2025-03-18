{ pkgs, ... }:
{
  projectRootFile = "flake.nix";
  programs = {
    black.enable = true;
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

  settings.formatter = {
    black.options = [ "--line-length=98" ];
  };

  settings.global.excludes = [
    ".editorconfig"
    ".envrc"
    ".prettierignore"
    "*.gitignore"
    "*.lock.hcl"
    "*.php"
    "*.png"
    "*.toml"
    "pkgs/astra-smt/COPYING"
    "servers/*"
  ];
}
