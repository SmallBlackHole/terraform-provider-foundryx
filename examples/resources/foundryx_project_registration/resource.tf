resource "foundryx_project_registration" "your-project" {
  project_arm_id = var.your-project-arm-id
}

variable "your-project-arm-id" {
  type        = string
  description = "ARM ID of an existing Foundry project; no native resources are created."
}
