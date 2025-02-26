variable "project_id" {
  description = "The GCP Project ID where the Cloud Run service will be created"
  type        = string
}

variable "region" {
  description = "The region where the Cloud Run service will be deployed"
  type        = string
}

variable "service_name" {
  description = "Name of the Cloud Run service"
  type        = string
}

variable "labels" {
  description = "Labels to apply to the Cloud Run service"
  type        = map(string)
  default     = {}
}

variable "image" {
  description = "Container image to deploy"
  type        = string
}

variable "shared_artifact_registry_project" {
  description = "The GCP Project ID where the shared Artifact Registry exists"
  type        = string
  default     = ""
}

variable "cpu" {
  description = "Number of CPU units for the service (e.g., '1000m' for 1 vCPU)"
  type        = string
  default     = "1000m" # Default to 1 vCPU
}

variable "memory" {
  description = "Memory allocation for the service (e.g., '512Mi', '1Gi')"
  type        = string
  default     = "512Mi" # Default to 512MB
}

variable "container_concurrency" {
  description = "Maximum number of concurrent requests per container (1-80, default 80)"
  type        = number
  default     = 80
}

variable "domain_mapping" {
  description = "Whether to map a domain to this Cloud Run service"
  type        = bool
  default     = false
}

variable "domain_name" {
  description = "The domain name to map to the Cloud Run service"
  type        = string
  default     = null
}

variable "dns_project_id" {
  description = "The GCP Project ID where the DNS zone exists (shared project)"
  type        = string
}

variable "dns_zone_name" {
  description = "The name of the DNS zone in the shared project"
  type        = string
}

variable "environment_secrets" {
  description = "Map of environment variable names to secret references"
  type = map(object({
    secret_name = string
    secret_key  = string
  }))
  default = {}
} 