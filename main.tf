# Enable Cloud Run API
resource "google_project_service" "cloud_run_api" {
  project = var.project_id
  service = "run.googleapis.com"

  disable_on_destroy = false
}

# Create Cloud Run service
resource "google_cloud_run_service" "service" {
  name     = var.service_name
  location = var.region
  project  = var.project_id

  template {
    spec {
      containers {
        image = var.image
      }
    }
  }

  lifecycle {
    ignore_changes = [
      template[0].spec[0].containers[0].image
    ]
  }

  depends_on = [google_project_service.cloud_run_api]
}

# Make the service public
resource "google_cloud_run_service_iam_member" "public" {
  project  = var.project_id
  location = var.region
  service  = google_cloud_run_service.service.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

# Add domain mapping if enabled
resource "google_cloud_run_domain_mapping" "domain_mapping" {
  count    = var.domain_mapping ? 1 : 0
  location = var.region
  project  = var.project_id
  name     = var.domain_name

  metadata {
    namespace = var.project_id
  }

  spec {
    route_name = google_cloud_run_service.service.name
  }

  depends_on = [google_cloud_run_service.service]
}

# Add DNS record for the domain mapping
resource "google_dns_record_set" "domain_mapping" {
  count = var.domain_mapping ? 1 : 0

  project      = var.dns_project_id
  name         = "${var.domain_name}."
  managed_zone = var.dns_zone_name
  type         = "CNAME"
  ttl          = 300
  rrdatas      = [google_cloud_run_domain_mapping.domain_mapping[0].status[0].resource_records[0].rrdata]

  depends_on = [google_cloud_run_domain_mapping.domain_mapping]
} 