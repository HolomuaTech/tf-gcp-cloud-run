variable "app_name" {
  type        = string
  description = "Name of the Cloud Run application"
}

variable "image" {
  type        = string
  description = "Docker image to deploy"
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

