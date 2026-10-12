resource "google_artifact_registry_repository" "registry" {
  location      = var.region
  repository_id = var.registry_repo_id
  description   = var.registry_repo_description
  format        = "DOCKER"
}