# Terraform Module Template

A reusable Terraform module template for AWS infrastructure. This template includes semantic versioning, automated releases, and best practices for module development.

## Features

- **Semantic Versioning**: Automated version management using conventional commits
- **Automated Releases**: GitHub releases with changelog generation
- **State Management**: Pre-configured S3 backend with DynamoDB locking
- **AWS Provider**: Terraform 1.8+ with AWS provider 5.0+
- **Pre-commit Hooks**: Code quality checks before commits

## Prerequisites

- Terraform >= 1.8.0
- AWS provider >= 5.0
- AWS credentials configured
- Git

## Getting Started

1. Clone or use this template to create a new repository
2. Update the backend configuration in `terraform/providers.tf` with your S3 bucket and DynamoDB table
3. Customize the module for your use case
4. Follow conventional commit messages for automatic versioning

## Backend Configuration

The module uses an S3 backend with DynamoDB state locking. Update `terraform/providers.tf`:

```hcl
terraform {
  backend "s3" {
    bucket         = "your-tfstate-bucket"
    key            = "your-module/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
```

## Conventional Commits

This template uses semantic-release with conventional commits:

- `feat:` - New features (minor version bump)
- `fix:` - Bug fixes (patch version bump)
- `perf:` - Performance improvements (patch version bump)
- `refactor:` - Code refactoring (patch version bump)
- `docs:` - Documentation updates (no release)
- `test:` - Test updates (no release)
- `chore:` - Maintenance tasks (no release)

## Development

1. Make changes to your module
2. Commit with conventional commit messages
3. Push to main branch
4. Automated release will create a GitHub release with changelog

## License

See LICENSE file for details.