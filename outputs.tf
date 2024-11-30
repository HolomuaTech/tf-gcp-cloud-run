output "cname_record" {
  description = "The DNS CNAME record for the Cloud Run service"
  value = {
    managed_zone = var.dns_zone_name
    name         = "${var.cname_subdomain}.${var.dns_name}"
    type         = "CNAME"
    ttl          = 300
    rrdatas      = ["ghs.googlehosted.com."]
  }
}

output "cloud_run_url" {
  description = "Public URL for the Cloud Run service"
  value       = google_cloud_run_service.default.status[0].url
}

output "domain_mapping" {
  description = "The Cloud Run domain mapping"
  value       = google_cloud_run_domain_mapping.domain_mapping.name
}

