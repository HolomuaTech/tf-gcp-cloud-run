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
}

output "cloud_run_url" {
  value = google_cloud_run_service.default.status[0].url
}

