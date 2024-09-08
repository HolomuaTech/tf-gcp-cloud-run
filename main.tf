resource "google_cloud_run_service" "default" {
  name     = var.app_name
  location = var.region

  template {
    spec {
      containers {
        image = var.image
        resources {
          # Minimal CPU and memory limits for cost savings
          limits = {
            memory = var.memory      # Set to 128Mi for minimal cost
            cpu    = var.cpu         # Set to 0.08 for minimal cost
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

# Scale down to zero instances when there are no requests
resource "google_cloud_run_service_iam_policy" "noauth" {
  location    = var.region
  project     = var.project_id
  service     = google_cloud_run_service.default.name
  policy_data = google_iam_policy.noauth.policy_data
}

output "cloud_run_url" {
  value = google_cloud_run_service.default.status[0].url
}

