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