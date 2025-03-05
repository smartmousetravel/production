{ lib, ... }:
{
  data = {
    google_storage_bucket_object.nixos_2411 = {
      name = "nixos-2411-vfivw1biz8j9qivjjhymajwq085nfdpb.raw.tar.gz";
      bucket = "smartmouse-images";
    };
  };

  resource = {
    google_compute_image.nixos_2411 = {
      name = "nixos-2411";
      family = "nixos-2411";
      raw_disk.source = lib.tfRef "data.google_storage_bucket_object.nixos_2411.self_link";
    };
  };
}
