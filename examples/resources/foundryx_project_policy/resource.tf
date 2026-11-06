resource "foundryx_project_policy" "your-policy" {
  project_id     = var.your-project-id
  allowed_models = ["your-deployment"]
  allowed_tools  = ["builtin:web_search"]
}

variable "your-project-id" {
  type        = string
  description = "UUID of an existing FoundryX registration."
}
