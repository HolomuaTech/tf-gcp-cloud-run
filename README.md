# Google Cloud Run Terraform Module

This Terraform module deploys and manages Google Cloud Run services with support for custom domains, IAM, and advanced container configurations.

## Features

- Deploys Cloud Run services with configurable container settings
- Supports environment variables and secrets
- Configurable resource limits and requests
- Custom domain mapping
- Flexible IAM permissions
- Volume mounts for secrets
- Container concurrency and timeout settings

## Usage

Basic usage with public access:

```hcl
module "cloud_run" {
  source = "../../tf-modules/tf-gcp-cloud-run"

  project_id   = "my-project"
  region       = "us-west1"
  service_name = "my-service"
  image        = "gcr.io/my-project/my-image:latest"

  # Make service public
  iam_members = {
    "public" = {
      role   = "roles/run.invoker"
      member = "allUsers"
    }
  }
}
```

## Examples

### Private Service with Environment Variables

```hcl
module "cloud_run" {
  source = "../../tf-modules/tf-gcp-cloud-run"

  project_id   = "my-project"
  region       = "us-west1"
  service_name = "private-service"
  image        = "gcr.io/my-project/private-service:latest"

  # Environment variables
  environment_variables = {
    "DB_HOST" = "localhost"
    "ENV"     = "production"
  }

  # Secret environment variables
  environment_secrets = {
    "DB_PASSWORD" = {
      secret_name = "db-password"
      secret_key  = "latest"
    }
  }

  # IAM - restrict access to specific service account
  iam_members = {
    "invoker" = {
      role   = "roles/run.invoker"
      member = "serviceAccount:my-service-account@my-project.iam.gserviceaccount.com"
    }
  }

  # Resource configuration
  resource_limits = {
    cpu    = "2000m"
    memory = "1Gi"
  }
  resource_requests = {
    cpu    = "1000m"
    memory = "512Mi"
  }
}
```

### Service with Domain Mapping and Custom Ports

```hcl
module "cloud_run" {
  source = "../../tf-modules/tf-gcp-cloud-run"

  project_id   = "my-project"
  region       = "us-west1"
  service_name = "web-service"
  image        = "gcr.io/my-project/web-service:latest"

  # Domain mapping
  domain_mapping = true
  domain_name    = "api.example.com"
  dns_project_id = "dns-project"
  dns_zone_name  = "example-zone"

  # Custom ports
  container_ports = [
    {
      name = "http1"
      port = 8080
    },
    {
      name = "metrics"
      port = 9090
    }
  ]

  # Service annotations
  service_annotations = {
    "run.googleapis.com/ingress" = "all"
  }

  # Template annotations
  template_annotations = {
    "autoscaling.knative.dev/maxScale" = "10"
  }
}
```

### Service with Volume Mounts and Advanced Settings

```hcl
module "cloud_run" {
  source = "../../tf-modules/tf-gcp-cloud-run"

  project_id   = "my-project"
  region       = "us-west1"
  service_name = "advanced-service"
  image        = "gcr.io/my-project/advanced-service:latest"

  # Volume mounts for secrets
  volume_mounts = {
    "config" = {
      mount_path = "/etc/config"
    }
  }

  volumes = {
    "config" = {
      secret_name = "service-config"
      secret_key  = "config.json"
      path        = "config.json"
    }
  }

  # Advanced settings
  container_concurrency = 50
  timeout_seconds      = 600

  # Service account
  service_account_name = "service-account@my-project.iam.gserviceaccount.com"
}
```

## Requirements

- Google Cloud Project with required APIs enabled
- Terraform >= 1.0
- Google Provider >= 4.0

## Providers

| Name | Version |
|------|---------|
| google | >= 4.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project_id | The GCP Project ID | `string` | n/a | yes |
| region | The region for the service | `string` | n/a | yes |
| service_name | Name of the service | `string` | n/a | yes |
| image | Container image to deploy | `string` | n/a | yes |
| environment_variables | Environment variables | `map(string)` | `{}` | no |
| environment_secrets | Secret environment variables | `map(object)` | `{}` | no |
| resource_limits | Resource limits | `map(string)` | See variables.tf | no |
| resource_requests | Resource requests | `map(string)` | See variables.tf | no |
| container_ports | Container ports | `list(object)` | See variables.tf | no |
| iam_members | IAM members | `map(object)` | `{}` | no |
| domain_mapping | Enable domain mapping | `bool` | `false` | no |
| domain_name | Domain name | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| service_url | The URL of the deployed service |
| service_id | The ID of the service |
| latest_ready_revision | The name of the latest ready revision |

## Notes

- Default resource limits and requests are configured for typical web services
- Domain mapping requires DNS zone in a specified project
- IAM is empty by default - you must explicitly grant access
- Container concurrency defaults to 80 requests per instance
- Request timeout defaults to 300 seconds

## Contributing

Please submit issues and pull requests for any improvements.

## License

Apache 2.0 Licensed. See LICENSE for full details. 