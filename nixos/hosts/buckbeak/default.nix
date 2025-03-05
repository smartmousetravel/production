{
  lib,
  modulesPath,
  ...
}:
{
  imports = [
    ../../common
    ./services
    (modulesPath + "/virtualisation/google-compute-image.nix")
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  fileSystems."/db" = {
    device = "/dev/disk/by-id/google-wp-db";
    fsType = "ext4";
  };

  fileSystems."/wp" = {
    device = "/dev/disk/by-id/google-wp-content";
    fsType = "ext4";
  };

  networking = {
    hostName = "buckbeak";
    domain = "smartmousetravel.com";
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.11";
}
