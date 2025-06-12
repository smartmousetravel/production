{ lib, ... }:
{
  security.sudo.wheelNeedsPassword = false;
  users = {
    # Users can only be made declaratively
    mutableUsers = false;
  };

  users.users.lucas = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    hashedPassword = "$6$fKBc6HqJQscMIW7h$Beoh3lUMAcHRh6uBhAyfAesGpl.ClHQlFe0Ox1VojG2tZ.Bu40sz4Hkjcm0budyFcjti5pNOUtDZi8qAUF5ZE1";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ2i5Qvu8pC44UPugMjyUx9bD44Dspovs2b5Kti2Qj13 lucas@snowball"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOau4E8GDV4xKNNxbHE3siF0FAkk+5e9NHhlKXvhU4MJ lucas@snowball-windows"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICxQDnZ2MZ0Q+APiJ7u3MnJ+T23uNTkwyf5R6YJwzX49 lucas@hedwig"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILqggWZJUgCELDtgl7bZu2Mpk16jVwFkkE5Ue5KVv/Ku lucas@pixel-9"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOU7WhR8A2pmvOk2HaiKUFWXUYxzkGEtKOXV0mW9MaGN slb@googoo-chromebox"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJU4UW9W4qHZrHsUk6ngTyf2Ht7LfcXkdEof+1nxylds slb@googoo-chromebook-linux"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN30FpKKW2kdcFb6XkZPhvM3WH6Abxz8RUAkZsbLIfrc slb@googoo-chromebook"
    ];
  };
}
