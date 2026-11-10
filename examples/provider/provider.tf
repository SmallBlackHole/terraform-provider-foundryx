terraform {
  required_version = ">= 1.7"
  required_providers {
    foundryx = {
      source  = "registry.terraform.io/smallblackhole/foundryx"
      version = "0.0.4"
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
