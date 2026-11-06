resource "foundryx_project_member" "your-group" {
  project_id     = var.your-project-id
  principal_type = "group"
  principal_id   = var.your-group-id
  role           = "user"
}

variable "your-project-id" {
  type        = string
  description = "UUID of an existing FoundryX registration."
}

variable "your-group-id" {
  type        = string
  description = "Existing group object UUID in the provider tenant."
}
