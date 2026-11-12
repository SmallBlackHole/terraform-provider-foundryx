# FoundryX Terraform provider

Manage FoundryX project registration, policy allowlists, and direct grants.

This repository distributes release packages, examples, and Terraform Registry documentation. Releases are built by the FoundryX pipeline in Skylight; provider implementation and CI remain there.

```hcl
terraform {
  required_providers {
    foundryx = {
      source  = "smallblackhole/foundryx"
      version = "0.0.5"
    }
  }
}
```

Run `terraform init` after the version has been published to the Terraform Registry.
The FoundryX CLI is a separate authentication prerequisite; it is not bundled.

See [provider configuration and authentication](docs/index.md), [the existing project access example](examples/existing-project-access/README.md), and [the complete access example](examples/all-in-one/main.tf).
