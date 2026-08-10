# KMS key for EKS secrets encryption
module "retail_app_eks_kms" {
  source  = "terraform-aws-modules/kms/aws"
  version = "~> 3.0"

  description             = "KMS key for ${local.cluster_name} EKS cluster secrets encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  key_administrators = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
  ]

  key_users = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
  ]

  # Use computed_aliases instead of aliases to handle dynamic cluster name
  computed_aliases = {
    cluster = {
      name = "eks/${local.cluster_name}"
    }
  }

  tags = local.tags
}

# EKS cluster
module "retail_app_eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = local.cluster_name
  cluster_version = var.cluster_version

  cluster_endpoint_public_access = true

  # KMS encryption for secrets
  cluster_encryption_config = {
    provider_key_arn = module.retail_app_eks_kms.key_arn
    resources        = ["secrets"]
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets

  # EKS Auto Mode managed node group
  cluster_compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  # Allow current IAM identity to administer the cluster
  enable_cluster_creator_admin_permissions = true

  tags = local.tags
}

# EKS cluster auth data source (used by other tooling / outputs)
data "aws_eks_cluster_auth" "cluster" {
  name = module.retail_app_eks.cluster_name
}
