variable "project_id" {
  type        = string
  description = "GCP Project ID"
}

variable "app_name" {
  type        = string
  description = "Name of the Cloud Run application"
}

variable "image" {
  type        = string
  description = "Docker image to deploy"
  default     = "gcr.io/google-samples/hello-app:1.0"
}

variable "region" {
  type        = string
  description = "Region for Cloud Run"
}

variable "memory" {
  type        = string
  description = "Memory limit for the Cloud Run service"
}

variable "cpu" {
  type        = string
  description = "CPU limit for the Cloud Run service"
}

# DNS Info
variable "dns_zone_name" {
  type        = string
  description = "Name of the GCP DNS zone resource for creating the CNAME record"
}

variable "dns_name" {
  type        = string
  description = "DNS domain name"
}

variable "cname_subdomain" {
  type        = string
  description = "Subdomain for the Cloud Run service's DNS record"
}

# Domain Mapping Info
variable "domain_name" {
  type        = string
  description = "Fully qualified domain name for the Cloud Run service"
}

variable "project_number" {
  type        = string
  description = "GCP project number"
}

# Artifact Registry info
variable "artifact_registry_repo_name" {
  type        = string
  description = "The name of the Artifact Registry repository."
}

variable "artifact_registry_repo_location" {
  type        = string
  description = "The location of the Artifact Registry repository."
}

variable "secret_version" {
  type        = string
  description = "Version of the secret to use (defaults to 'latest')"
  default     = "latest"
}

variable "public_env_vars" {
  description = "Public environment variables as key-value pairs."
  type        = map(string)
  default     = {}
}

variable "secret_env_vars" {
  description = "Private environment variables with key-value pairs of environment variable names and secret names."
  type        = map(string)
  default     = {}
}

# Variable to control Cloud SQL access
variable "grant_cloudsql_access" {
  type        = bool
  description = "Whether to grant Cloud SQL client access to the service account"
  default     = false
}

