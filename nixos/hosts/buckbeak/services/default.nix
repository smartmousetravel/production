{ pkgs, ... }:
{
  imports = [
    ./monitoring.nix
    ./wordpress.nix
  ];

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    dataDir = "/db/mysql";
  };
}
