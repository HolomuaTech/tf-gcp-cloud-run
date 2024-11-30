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

# Grant Access to Google Container Registry (gcr.io)
resource "google_project_iam_member" "grant_gcr_access" {
  count   = var.service_account_email == null ? 1 : 0
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.cloud_run_sa[0].email}"
}

# Grant Artifact Registry access to the Service Account
resource "google_artifact_registry_repository_iam_member" "grant_artifact_access" {
  count       = var.service_account_email == null ? 1 : 0
  project     = var.project_id
  location    = var.artifact_registry_repo_location
  repository  = var.artifact_registry_repo_name
  role        = "roles/artifactregistry.reader"
  member      = "serviceAccount:${google_service_account.cloud_run_sa[0].email}"
}

