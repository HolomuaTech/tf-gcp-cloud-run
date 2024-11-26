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
