resource "google_cloud_run_service" "this" {
  name     = var.cloud_service_name
  location = var.region

  template {
    metadata {
      annotations = {
        "autoscaling.knative.dev/minScale"         = "1"
        "autoscaling.knative.dev/maxScale"         = "3"
        "run.googleapis.com/scaling-cpu-target"    = "0.5"
        "run.googleapis.com/execution-environment" = "gen1"
        "run.googleapis.com/cpu-throttling"        = "true"
        "run.googleapis.com/vpc-access-connector"  = var.vpc_connector_id
        "run.googleapis.com/vpc-access-egress"     = "private-ranges-only"
      }
    }
    spec {
      service_account_name  = google_service_account.run.email
      container_concurrency = 1
      containers {
        image = var.image

        env {
          name = "APP_SECRET"
          value_from {
            secret_key_ref {
              name = google_secret_manager_secret.app.secret_id
              key  = "latest"

            }
          }
        }
        resources {
          limits = {
            "cpu"    = "0.25"
            "memory" = "512Mi"
          }
        }

      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service_iam_member" "public" {
  project  = google_cloud_run_service.this.project
  location = google_cloud_run_service.this.location
  service  = google_cloud_run_service.this.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

resource "google_logging_project_bucket_config" "cloudrun" {
  project        = var.project_id
  location       = var.region
  bucket_id      = "cloudrun-logs"
  retention_days = 14
}

resource "google_logging_project_sink" "cloudrun" {
  name        = "cloudrun-sink"
  project     = var.project_id
  destination = "logging.googleapis.com/${google_logging_project_bucket_config.cloudrun.id}"
  filter      = "resource.type=\"cloud_run_revision\""
}
