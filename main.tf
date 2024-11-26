# Create a Service Account for the Cloud Run service
resource "google_service_account" "cloud_run_sa" {
  count        = var.service_account_email == null ? 1 : 0
  account_id   = "${var.app_name}-sa"
  display_name = "${var.app_name} Cloud Run Service Account"
}

# Grant Secret Manager Access to the Service Account
resource "google_project_iam_member" "grant_secret_access" {
  count   = var.service_account_email == null ? 1 : 0
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.cloud_run_sa[0].email}"
}

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

        # Add environment variable for the database connection
        dynamic "env" {
          for_each = var.postgres_secret_name != null ? [1] : []
          content {
            name = "POSTGRES_CONNECTION"
            value_from {
              secret_key_ref {
                name = var.postgres_secret_name
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

# Create DNS record
resource "google_dns_record_set" "cname_record" {
  managed_zone = var.dns_zone_name
  name         = "${var.cname_subdomain}.${var.dns_name}"
  type         = "CNAME"
  ttl          = 300
  rrdatas      = ["ghs.googlehosted.com."]
}

# Allow unauthenticated access to the Cloud Run service
resource "google_cloud_run_service_iam_member" "noauth" {
  service  = google_cloud_run_service.default.name
  location = var.region
  role     = "roles/run.invoker"
  member   = "allUsers"
}

# Create Cloud Run domain mapping
resource "google_cloud_run_domain_mapping" "domain_mapping" {
  name     = var.domain_name
  location = var.region

  metadata {
    namespace = var.project_number
    annotations = {
      "run.googleapis.com/override-headers" = "X-Forwarded-Proto=https"
    }
  }

  spec {
    route_name       = var.app_name
    certificate_mode = "AUTOMATIC"
  }

  lifecycle {
    ignore_changes = [
      metadata[0].annotations,
      metadata[0].namespace,
      spec[0].force_override
    ]
  }
}

