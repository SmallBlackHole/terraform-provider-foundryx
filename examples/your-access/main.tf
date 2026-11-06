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
  type = string
}
variable "your-project-arm-id" {
  type = string
}
variable "your-user-id" {
  type = string
}
variable "your-group-id" {
  type = string
}

resource "foundryx_project_registration" "your-project" {
  project_arm_id = var.your-project-arm-id
}

resource "foundryx_project_policy" "your-policy" {
  project_id     = foundryx_project_registration.your-project.project_id
  allowed_models = ["your-deployment"]
  allowed_tools  = ["builtin:web_search", "connection:your-search"]
}

resource "foundryx_project_member" "your-user" {
  project_id     = foundryx_project_registration.your-project.project_id
  principal_type = "user"
  principal_id   = var.your-user-id
  role           = "owner"
  depends_on     = [foundryx_project_policy.your-policy]
}

resource "foundryx_project_member" "your-group" {
  project_id     = foundryx_project_registration.your-project.project_id
  principal_type = "group"
  principal_id   = var.your-group-id
  role           = "user"
  depends_on     = [foundryx_project_policy.your-policy]
}

resource "foundryx_project_member" "your-tenant-consumers" {
  project_id     = foundryx_project_registration.your-project.project_id
  principal_type = "tenant"
  principal_id   = var.your-tenant-id
  role           = "consumer"
  depends_on     = [foundryx_project_policy.your-policy]
}
