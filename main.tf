# Enable Cloud Run API
resource "google_project_service" "cloud_run_api" {
  project = var.project_id
  service = "run.googleapis.com"

  disable_on_destroy = false
}

# Get project data for service account
data "google_project" "project" {
  project_id = var.project_id
}

# Grant Artifact Registry reader permission in shared project for Cloud Run service agent
resource "google_project_iam_member" "shared_project_permissions" {
  count = var.shared_artifact_registry_project != "" ? 1 : 0

  project = var.shared_artifact_registry_project
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:service-${data.google_project.project.number}@serverless-robot-prod.iam.gserviceaccount.com"
}

# Create Cloud Run service
resource "google_cloud_run_service" "service" {
  name     = var.service_name
  location = var.region
  project  = var.project_id

  template {
    spec {
      container_concurrency = var.container_concurrency
      
      containers {
        image = var.image
        
        resources {
          limits = {
            cpu    = var.cpu
            memory = var.memory
          }
        }
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