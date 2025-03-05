{
  inputs,
  lib,
  ...
}:
{
  imports = [ ./users.nix ];

  nix = {
    # Harmonize the Nix registry with this flake's inputs
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;

      # Let anyone in the wheel group have extra rights with Nix. This is needed in
      # particular for doing nixos-rebuild over SSH to a machine that doesn't allow
      # remote logins from root.
      trusted-users = [
        "root"
        "@wheel"
      ];
    };
  };

  time.timeZone = lib.mkDefault "Etc/UTC";
  i18n.defaultLocale = "en_US.UTF-8";

  networking.firewall.enable = true;

  services.openssh = {
    enable = lib.mkDefault true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };
}
