{ pkgs, ... }:
{
  astra-smt = import ./astra-smt { inherit pkgs; };
}
