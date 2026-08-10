locals {
  cluster_name = "${var.cluster_name}-${random_string.suffix.result}"

  # Availability zones — use first 3
  azs = slice(data.aws_availability_zones.available.names, 0, 3)

  # Subnet CIDRs derived from the VPC CIDR
  private_subnets = [for i, az in local.azs : cidrsubnet(var.vpc_cidr, 4, i)]
  public_subnets  = [for i, az in local.azs : cidrsubnet(var.vpc_cidr, 8, i + 48)]

  tags = {
    Environment = var.environment
    Project     = "retail-store"
    ManagedBy   = "terraform"
  }
}

# Random suffix to keep cluster name unique (matches tfstate value "1iuv")
resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

# Data sources
data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_caller_identity" "current" {}
