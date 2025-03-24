This directory contains Nix language expressions that use
[Terranix](https://terranix.org/) to generate [Terraform](https://www.terraform.io/)
configuration. Use `nix run .#terraform-ACTION` to perform some work:

-   `config`: Generate a JSON configuration file, useful for debugging
-   `plan`: Generate a plan file and show pending actions
-   `apply`: Actually apply the plan; you must run `nix run .#terraform-plan` first
