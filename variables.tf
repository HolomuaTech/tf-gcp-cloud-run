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

variable "secret_name" {
  type        = string
  description = "Name of the Google Secret Manager secret to inject into the Cloud Run service"
  default     = null
}

variable "secret_key" {
  type        = string
  description = "Key of the secret to use in the Cloud Run service"
  default     = null
}

variable "env_variable_name" {
  type        = string
  description = "Environment variable name for the secret in the container"
  default     = null
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
