{ lib, ... }:
{
  resource = {
    google_service_account.buckbeak = {
      account_id = "buckbeak";
      display_name = "buckbeak instance service account";
    };

    google_project_iam_member.buckbeak_acme_dns = {
      project = lib.tfRef "var.gcp_project";
      role = lib.tfRef "google_project_iam_custom_role.acme_dns.name";
      member = "serviceAccount:\${google_service_account.buckbeak.email}";
    };

    google_compute_disk = {
      buckbeak_wp_content = {
        name = "buckbeak-wp-content";
        size = 30;
        lifecycle.prevent_destroy = true;
      };
      buckbeak_wp_db = {
        name = "buckbeak-wp-db";
        size = 15;
        lifecycle.prevent_destroy = true;
      };
    };

    google_compute_address.buckbeak = {
      name = "buckbeak";
    };

    google_compute_instance.buckbeak = {
      name = "buckbeak";
      machine_type = "e2-medium";
      tags = [
        "http-server"
        "https-server"
      ];

      boot_disk = {
        initialize_params = {
          size = 30;
          image = lib.tfRef "google_compute_image.nixos_2411.id";
        };
      };

      attached_disk = [
        {
          source = lib.tfRef "google_compute_disk.buckbeak_wp_content.self_link";
          device_name = "wp-content";
        }
        {
          source = lib.tfRef "google_compute_disk.buckbeak_wp_db.self_link";
          device_name = "wp-db";
        }
      ];

      network_interface = {
        network = "default";
        access_config = {
          nat_ip = lib.tfRef "google_compute_address.buckbeak.address";
        };
      };

      service_account = {
        email = lib.tfRef "google_service_account.buckbeak.email";
        scopes = [ "cloud-platform" ];
      };
    };

    google_dns_record_set.smartmouse_a_buckbeak = {
      name = "buckbeak.smartmousetravel.com.";
      managed_zone = "smartmouse";
      type = "A";
      ttl = 300;
      rrdatas = [ (lib.tfRef "google_compute_address.buckbeak.address") ];
    };
  };
}
