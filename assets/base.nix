{ lib, ... }:
{
  terraform = {
    required_providers = {
      google.source = "hashicorp/google";
    };

    backend.gcs = {
      bucket = "smartmouse-tf-state";
      prefix = "terraform/state";
    };
  };

  provider = {
    google = {
      project = lib.tfRef "var.gcp_project";
      zone = lib.tfRef "var.gcp_location";
    };
  };
}
