terraform {
  required_version = ">= 1.7"
  required_providers {
    foundryx = {
      source  = "registry.terraform.io/smallblackhole/foundryx"
      version = "0.0.5"
    }
  }
}

provider "foundryx" {
  tenant_id = var.your-tenant-id
}

variable "your-tenant-id" {
  type        = string
  description = "Entra tenant UUID matching the signed-in FoundryX CLI session."
}

variable "your-project-arm-id" {
  type        = string
  description = "ARM ID of the existing Foundry project; no projects, deployments, or tools are created, but registration may provision Azure RBAC."
}

variable "your-model-deployment-names" {
  type        = set(string)
  description = "Complete allowlist of existing model deployment names for this project."
}

variable "your-tool-keys" {
  type        = set(string)
  description = "Complete allowlist of existing builtin:, connection:, and toolbox: keys."
}

variable "your-recipient-object-id" {
  type        = string
  description = "Entra object UUID of the user receiving Consumer access."
}

resource "foundryx_project_registration" "your-project" {
  project_arm_id = var.your-project-arm-id
}

resource "foundryx_project_policy" "your-policy" {
  project_id     = foundryx_project_registration.your-project.project_id
  allowed_models = var.your-model-deployment-names
  allowed_tools  = var.your-tool-keys
}

resource "foundryx_project_member" "your-recipient" {
  project_id     = foundryx_project_registration.your-project.project_id
  principal_type = "user"
  principal_id   = var.your-recipient-object-id
  role           = "consumer"
  depends_on     = [foundryx_project_policy.your-policy]
}
