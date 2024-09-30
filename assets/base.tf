terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
  backend "gcs" {
    bucket = "smartmouse-tf-state"
    prefix = "terraform/state"
  }
}

provider "google" {
  project = var.gcp_project
}
