# Create DNS record dynamically
resource "google_dns_record_set" "cname_record" {
  managed_zone = var.dns_zone_name
  name         = "${var.cname_subdomain}.${var.dns_name}."
  type         = "CNAME"
  ttl          = 300

  # Use the domain name dynamically
  rrdatas = [google_cloud_run_domain_mapping.domain_mapping.spec[0].route_name]
  
  depends_on = [google_cloud_run_domain_mapping.domain_mapping]
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

# Allow unauthenticated access to the Cloud Run service
resource "google_cloud_run_service_iam_member" "noauth" {
  service  = google_cloud_run_service.default.name
  location = var.region
  role     = "roles/run.invoker"
  member   = "allUsers"
}

