output "cname_record" {
  description = "The DNS CNAME record for the Cloud Run service"
  value = {
    managed_zone = var.dns_zone_name
    name         = "${var.cname_subdomain}.${var.dns_zone_name}."
    type         = "CNAME"
    ttl          = 300
    rrdatas      = ["ghs.googlehosted.com."]
  }
}

output "cloud_run_url" {
  value = google_cloud_run_service.default.status[0].url
}
