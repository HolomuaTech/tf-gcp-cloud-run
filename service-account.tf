# Create a Service Account for the Cloud Run service
resource "google_service_account" "cloud_run_sa" {
  account_id   = "${var.app_name}-sa"
  display_name = "${var.app_name} Cloud Run Service Account"
}

# Define the service account email
locals {
  service_account_email = google_service_account.cloud_run_sa.email
}

# Grant Secret Manager Access to the Service Account
resource "google_project_iam_member" "grant_secret_access" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${local.service_account_email}"
}

# Grant Access to Artifact Registry
resource "google_project_iam_member" "grant_gcr_access" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${local.service_account_email}"
}

# Grant Artifact Registry access to the Service Account
resource "google_artifact_registry_repository_iam_member" "grant_artifact_access" {
  project     = var.project_id
  location    = var.artifact_registry_repo_location
  repository  = var.artifact_registry_repo_name
  role        = "roles/artifactregistry.reader"
  member      = "serviceAccount:${local.service_account_email}"
}

# Conditionally grant Cloud SQL Client access to the Service Account
resource "google_project_iam_member" "grant_cloudsql_access" {
  count   = var.grant_cloudsql_access ? 1 : 0
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${local.service_account_email}"
}

