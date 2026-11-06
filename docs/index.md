---
page_title: "FoundryX Provider"
description: "Manage FoundryX project registration, policy allowlists, and direct grants."
---

# FoundryX provider

Provider source: `registry.terraform.io/smallblackhole/foundryx`.
This provider calls FoundryX directly and
automatically reuses the signed-in FoundryX CLI session.

```terraform
terraform {
  required_version = ">= 1.7"
  required_providers {
    foundryx = {
      source  = "registry.terraform.io/smallblackhole/foundryx"
      version = "0.0.2"
    }
  }
}

provider "foundryx" {
  tenant_id = var.your-tenant-id
}

variable "your-tenant-id" {
  type        = string
  description = "Tenant UUID matching the signed-in CLI session or explicit delegated token."
}
```

The provider connects to **staging** by default. `tenant_id` selects the customer
tenant and remains required.

Download a standalone CLI from the
[FoundryX releases](https://github.com/microsoft/FoundryX/releases?q=FoundryX&expanded=true)
for the provider service environment, OS, and architecture. Standalone binaries
do not require Node.js or npm. Terraform does not install the CLI.

Sign in separately with `foundryx auth login --tenant <your-tenant-id>` using a CLI build
with generic `auth get-access-token` support for the same service environment.
The installed CLI owns authentication and silent refresh; business requests go
directly from the provider to the API. No token copying is needed. The CLI service
profile and selected tenant must match the provider. Set `FOUNDRYX_CLI_PATH` to the
matching native executable or its `bin\foundryx.js` entrypoint when it is not on `PATH`; shell
wrappers are not executed. The JavaScript entrypoint requires Node.js.

Tokens are cached only in memory until one minute before their actual MSAL
expiry. The provider pins the account and session on refresh. Logout, re-login,
account switching, or expired consent stop the run on the next credential
acquisition, not on every API request. Cached bearer tokens are not immediately
invalidated by CLI logout. Review the account and rerun Terraform after a session
change. Terraform never starts interactive or password sign-in. If the CLI is
missing or credential acquisition fails, Terraform reports an error with the
download link and sign-in instructions; sign in separately and rerun Terraform.

`auth get-access-token` returns sensitive bearer credentials over a captured
pipe, never through Terraform configuration, plans, state, logs, or diagnostics.
Do not run the command in recorded terminals or save its output to files. The
provider does not read keyring/MSAL caches or implement MSAL itself.

The CLI acquires tokens only for its configured FoundryX API, never arbitrary
scopes or audiences. Sign-in/consent requirements fail explicitly; sign in
separately before restarting the caller.

An optional `FOUNDRYX_ACCESS_TOKEN` overrides CLI authentication; it must be a
delegated FoundryX API token and is not refreshed. Never put tokens in HCL.
Workload identity is not supported. Optional `FOUNDRYX_CA_CERT_FILE` adds
explicit PEM trust roots without disabling TLS verification.


## Schema

### Required

- `tenant_id` (String) Entra tenant UUID for the delegated session.

Register deny-all, configure complete policy allowlists, then grant memberships
with an explicit policy dependency. Import existing registrations and grants
before managing them. Updates can overwrite edits made after planning; there is
no stale-plan protection.

Creation uses stable resource identities and atomic create-only checks, without a
durable request ledger. An existing registration or direct grant requires import.
If a create response is lost before state is saved, inspect FoundryX and import
the created access; the provider does not automatically replay ambiguous mutations.
Incomplete registration setup must be recovered through FoundryX or removed before
retrying creation.

Separate policy deletion is unsupported and retains state. Use an explicit
state-only handoff before registration removal, which removes **all** FoundryX
project access but retains native Azure resources.

See the [CLI guide](https://github.com/microsoft/FoundryX#install-the-cli) for installation and sign-in.
