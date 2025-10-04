# ARM64 Example

This example demonstrates how to deploy HCP Terraform agents on ARM64 architecture using AWS Fargate.

## Key Features

- Uses ARM64 CPU architecture for potentially better cost efficiency
- Deploys on Fargate Spot instances for additional cost savings
- Creates a new VPC with private subnets for secure agent deployment

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## Configuration

The example sets `cpu_architecture = "ARM64"` to deploy agents on ARM64-based Fargate instances instead of the default x86_64 architecture.
