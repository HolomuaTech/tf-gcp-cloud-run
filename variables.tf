variable "app_name" {
  type        = string
  description = "Name of the Cloud Run application"
}

variable "env_vars" {
  type        = map(string)
  description = "Environment variables for the container"
  default     = {}
}

variable "image" {
  type        = string
  description = "Docker image to deploy"
  default     = "gcr.io/google-containers/nginx:latest"  # Default to public Nginx image
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

