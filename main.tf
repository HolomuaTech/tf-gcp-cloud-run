# tf-gcp-cloud-run/main.tf

resource "google_cloud_run_service" "default" {
  name     = var.app_name
  location = var.region

  template {
    spec {
      containers {
        image = var.image

        resources {
          limits = {
            memory = var.memory
            cpu    = var.cpu
          }
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  autogenerate_revision_name = true
}

# Allow unauthenticated access to the Cloud Run service
resource "google_cloud_run_service_iam_member" "noauth" {
  service  = google_cloud_run_service.default.name
  location = var.region
  role     = "roles/run.invoker"
  member   = "allUsers"  # This allows unauthenticated access
}

# Output the URL of the Cloud Run service
output "cloud_run_url" {
  value = google_cloud_run_service.default.status[0].url
}

