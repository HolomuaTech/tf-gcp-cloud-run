# Cloud Run Service
resource "google_cloud_run_service" "default" {
  name     = var.app_name
  location = var.region

  template {
    spec {
      # Use the service account if provided, otherwise use the one created above
      service_account_name = var.service_account_email != null ? var.service_account_email : google_service_account.cloud_run_sa[0].email

      containers {
        image = var.image

        resources {
          limits = {
            memory = var.memory
            cpu    = var.cpu
          }
        }

        # Public environment variables
        dynamic "env" {
          for_each = var.public_env_vars
          content {
            name  = env.key
            value = env.value
          }
        }

        # Private (secret-backed) environment variables
        dynamic "env" {
          for_each = var.secret_env_vars
          content {
            name = env.key
            value_from {
              secret_key_ref {
                name = env.value
                key  = var.secret_version
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

