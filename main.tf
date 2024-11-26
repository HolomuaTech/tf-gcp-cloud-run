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

        # Add environment variables if secrets are provided
        dynamic "env" {
          for_each = var.secret_name != null && var.secret_key != null ? [1] : []
          content {
            name = var.env_variable_name
            value_from {
              secret_key_ref {
                name = var.secret_name
                key  = var.secret_key
              }
            }
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

  lifecycle {
    ignore_changes = [
      template[0].spec[0].containers[0].image,
    ]
  }
}

# Allow unauthenticated access to the Cloud Run service
resource "google_cloud_run_service_iam_member" "noauth" {
  service  = google_cloud_run_service.default.name
  location = var.region
  role     = "roles/run.invoker"
  member   = "allUsers"
}

# Output the URL of the Cloud Run service
output "cloud_run_url" {
  value = google_cloud_run_service.default.status[0].url
}

