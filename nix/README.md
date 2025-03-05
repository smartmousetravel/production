On a NixOS host, to generate an image for Google Compute Engine, run:

```shell
$ nix build --no-link --json ".#nixosConfigurations.buckbeak.config.system.build.googleComputeImage"
$ gsutil cp RESULT_PATH gs://smartmouse-images/nixos-2411-aaaabbbbcccc.tar.gz
```
