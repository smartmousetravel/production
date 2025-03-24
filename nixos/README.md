This directory contains NixOS configurations for servers. Survival commands:

```shell
# Maybe update our "inputs" that go into building the host configuration
$ nix flake update

# Build the host configuration
# (Use boot or switch to apply the new config on (resp) next boot or immediately)
$ nixos-rebuild \
    --flake .#buckbeak \
    --target-host lucas@buckbeak.smartmousetravel.com \
    --use-remote-sudo \
    build
```

On a NixOS host, to generate an image for Google Compute Engine, run:

```shell
$ nix build --no-link --json ".#nixosConfigurations.buckbeak.config.system.build.googleComputeImage"
$ gsutil cp RESULT_PATH gs://smartmouse-images/nixos-2411-aaaabbbbcccc.tar.gz
```
