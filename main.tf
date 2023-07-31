# Setup terraform cloud and workspace
terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "lanandra"

    workspaces {
      name = "vpc-ap-southeast-1"
    }
  }
}

# Setup terraform providers
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.74.0"
    }
  }

  required_version = ">= 1.1.5"
}

# Setup AWS provider
provider "aws" {
  region = var.aws_region
}