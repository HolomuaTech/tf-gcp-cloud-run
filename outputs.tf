output "service_name" {
  description = "Name of the Cloud Run service"
  value       = google_cloud_run_service.service.name
}

output "service_url" {
  description = "URL of the Cloud Run service"
  value       = google_cloud_run_service.service.status[0].url
}

output "service_id" {
  description = "Unique identifier for the Cloud Run service"
  value       = google_cloud_run_service.service.id
}

output "domain_mapping_records" {
  description = "DNS records required for domain mapping"
  value       = var.domain_mapping ? google_cloud_run_domain_mapping.domain_mapping[0].status[0].resource_records : []
} 