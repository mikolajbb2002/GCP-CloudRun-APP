variable "region" {
  description = "Domyślny region dla zasobów Google Cloud."
  type        = string
  default     = "europe-west3"
}

variable "project_id" {
  type = string
}

variable "github_repo" {
  type = string
}

variable "state_bucket_name" {
  type = string
}