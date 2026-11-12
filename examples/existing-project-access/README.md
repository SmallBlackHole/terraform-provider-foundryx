# Grant Consumer access to an existing Foundry project

This example registers an existing Foundry project with FoundryX, sets the
project's complete model and tool allowlists, and grants one Entra user the
Consumer role. It creates no Foundry projects, model deployments, or tools;
these must already exist. Registration can create Azure custom role definitions
and role assignments for the FoundryX service principal at project, account, and
resource-group scopes. The recipient receives FoundryX access, not Azure RBAC.

## Inputs

Set these variables in a local `terraform.tfvars` file (do not commit it):

| Variable | Value |
| --- | --- |
| `your-tenant-id` | Entra tenant UUID matching the FoundryX CLI session |
| `your-project-arm-id` | ARM ID of the existing Foundry project |
| `your-model-deployment-names` | Set of all deployment names to allow |
| `your-tool-keys` | Set of all tool keys to allow, such as `builtin:web_search` or `connection:your-search` |
| `your-recipient-object-id` | Entra object UUID of the user to grant access |

Both allowlists are complete replacements, not additions. An empty set allows
nothing. Obtain the exact deployment names and tool keys from the project; names
and keys are case-sensitive. Sign in separately with the FoundryX CLI for the
same tenant before running Terraform.

The signed-in administrator needs FoundryX Access management authority at
subscription scope: Subscription Owner, Contributor + User Access Administrator,
or a custom role with the required permissions, including reading and writing
role definitions and reading, writing, and deleting role assignments. FoundryX
uses the administrator's delegated Azure permissions to provision the service
principal's access. An Entra tenant administrator role alone is insufficient.

## Existing FoundryX access

An existing native Foundry project is not itself imported into Terraform:
registration enables FoundryX access to it and may provision the Azure RBAC
described above. If FoundryX already has a registration, policy, or direct grant
for this project, import each existing record into its matching Terraform
resource before applying. Existing grants are not adopted automatically, even if
the role already matches.

Use the FoundryX project UUID and tenant UUID in these import IDs:

```text
terraform import foundryx_project_registration.your-project "<tenant-id>/<project-id>"
terraform import foundryx_project_policy.your-policy "<tenant-id>/<project-id>"
terraform import foundryx_project_member.your-recipient "<tenant-id>/<project-id>/user/<recipient-object-id>"
```

Only import the records that already exist. Review the resulting plan: policy
differences replace the complete allowlists with the configured sets.

## Safe removal

To revoke only this recipient's direct grant, remove the
`foundryx_project_member.your-recipient` block and apply the reviewed plan. Other
grants, policy, registration, and native resources remain.

Policy cannot be independently deleted. Before removing all FoundryX access
through Terraform, first replace the policy block with this state-only handoff
and, in the same edit, remove
`depends_on = [foundryx_project_policy.your-policy]` from
`foundryx_project_member.your-recipient`. Apply while keeping the membership and
registration configured. Leaving that dependency would reference an undeclared
resource and prevent Terraform from planning the handoff.

```terraform
removed {
  from = foundryx_project_policy.your-policy
  lifecycle {
    destroy = false
  }
}
```

Then remove the membership and registration blocks and apply. Removing the
registration revokes all FoundryX project grants, including grants managed
outside this configuration, but leaves the native Foundry project, deployments,
and tools intact. Review the plan carefully; do not use a one-step destroy.
