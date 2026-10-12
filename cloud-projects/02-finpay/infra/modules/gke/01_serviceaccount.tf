resource "google_service_account" "run" {
  project    = var.project_id
  account_id = var.account_id
}

resource "google_secret_manager_secret" "app" {
  project   = var.project_id
  secret_id = var.secret_id

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_iam_member" "run_access" {
  project   = var.project_id
  secret_id = google_secret_manager_secret.app.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.run.email}"
}
