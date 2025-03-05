On a NixOS host, to generate an image for Google Compute Engine, run:

```shell
$ nix-build '<nixpkgs/nixos/lib/eval-config.nix>' \
   -A config.system.build.googleComputeImage \
   --arg modules "[ <nixpkgs/nixos/modules/virtualisation/google-compute-image.nix> ]" \
   --argstr system x86_64-linux \
   -o gce

$ gsutil cp RESULT_PATH gs://smartmouse-images/nixos-2411-aaaabbbbcccc.tar.gz
```
