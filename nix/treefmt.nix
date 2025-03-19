{ pkgs, ... }:
{
  projectRootFile = "flake.nix";
  programs = {
    black.enable = true;
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
    "*.map"
    "*.php"
    "*.png"
    "*.toml"
    "pkgs/astra-smt/COPYING"
    "servers/*"
  ];
}
