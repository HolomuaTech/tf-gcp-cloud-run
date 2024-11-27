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

variable "service_account_name" {
  description = "Service account to use for Cloud Run"
  type        = string
}

variable "memory" {
  type        = string
  description = "Memory limit for the Cloud Run service"
}

variable "cpu" {
  type        = string
  description = "CPU limit for the Cloud Run service"
}

variable "postgres_secret_name" {
  type        = string
  description = "The name of the Google Secret Manager secret storing PostgreSQL connection details"
  default     = null
}

variable "secret_key" {
  type        = string
  description = "Key of the secret to use in the Cloud Run service"
  default     = "latest"
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

variable "service_account_email" {
  type        = string
  description = "Email of the service account to use with Cloud Run. If not provided, a new one will be created."
  default     = null
}
