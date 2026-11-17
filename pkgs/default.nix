{ pkgs, pyproject-nix, ... }:
{
  astra-smt = import ./astra-smt { inherit pkgs; };
  wp-plugin-info = import ./wp_plugin_info { inherit pkgs pyproject-nix; };
}
