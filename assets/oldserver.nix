{ lib, ... }:
{
  resource = {
    google_compute_disk = {
      wp_content_old = {
        name = "www-wp-content";
        size = 30;
        snapshot = "smartmouse-web-cont-us-east1-b-20210206054844-iveqdlq7";
        lifecycle.prevent_destroy = true;
      };
      wp_db_old = {
        name = "www-wp-db";
        size = 15;
        snapshot = "smartmouse-web-db-r-us-east1-b-20210206054844-0zyo93yx";
        lifecycle.prevent_destroy = true;
      };
    };

    google_compute_address.www_old = {
      name = "www-prod-1";
    };

    google_compute_instance.www_old = {
      name = "www-prod-1";
      machine_type = "n1-standard-1";

      boot_disk = {
        initialize_params = {
          image = "ubuntu-os-cloud/ubuntu-2004-lts";
        };
      };

      attached_disk = [
        {
          device_name = "www-wp-db";
          source = "https://www.googleapis.com/compute/v1/projects/smartmouse-web/zones/us-east1-b/disks/www-wp-db";
        }
        {
          device_name = "www-wp-content";
          source = "https://www.googleapis.com/compute/v1/projects/smartmouse-web/zones/us-east1-b/disks/www-wp-content";
        }
      ];

      network_interface = {
        network = "default";
        access_config = {
          nat_ip = lib.tfRef "google_compute_address.www_old.address";
        };
      };

      metadata.ssh_keys = builtins.concatStringsSep "\n" [
        "lucas:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDaG6ymV9+xfeEeGySrS43dtXspJRgX4yk6Xf8NzHEeTvg/AC+fIt/Jup6dEVDQtlljEH+Emv34AajlCIQEQY/zVIrbLPoj7k6yw74X6xl9ZLjnAnSvOkTwVXWNmNKnW+DgEvWI2jsQakl9+rRxJS5rmgG/73zGHAir4mWtLL+ZzwHy0Lg+o+IbRQTIBcpaUqaWglZKN+2copJZMvZXkD1MUByL4L8gjRiKcqiAdapvAVtEctuAygBDdkCdM3hrA6KXn+4AzzX0RzMQ5UZ28xTS/4TGaopAtvBoOMwFTo3FoCO42jRXsEHIhcjDtzPqvAyqURRyuK8/ls7+I8Tp8+Mx lucas@ansible"
        "lucas:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICxQDnZ2MZ0Q+APiJ7u3MnJ+T23uNTkwyf5R6YJwzX49 lucas@hedwig"
        "lucas:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINuyzoB4G20JKZBHcNP7dDBgHq9FyhAmzhEMcOaZgifr lucas@cheddar"
      ];

      tags = [
        "http-server"
        "https-server"
      ];

      service_account = {
        email = "643164261097-compute@developer.gserviceaccount.com";
        scopes = [
          "https://www.googleapis.com/auth/devstorage.read_only"
          "https://www.googleapis.com/auth/logging.write"
          "https://www.googleapis.com/auth/monitoring.write"
          "https://www.googleapis.com/auth/service.management.readonly"
          "https://www.googleapis.com/auth/servicecontrol"
          "https://www.googleapis.com/auth/trace.append"
        ];
      };
    };
  };
}
