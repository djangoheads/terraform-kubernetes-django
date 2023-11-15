data "aws_rds_cluster" "development" {
  cluster_identifier = "development-postgres-aurora-serverless-cluster"
}

data "aws_eks_cluster" "main" {
  name = var.aws_eks_cluster_name
}

data "aws_eks_cluster_auth" "main" {
  name = var.aws_eks_cluster_name
}

provider "aws" {
  region                      = "eu-central-1"
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true

  assume_role {
    role_arn    = "arn:aws:iam::387673871354:role/OrganizationAccountAccessRole"
  }
}

provider "postgresql" {
  scheme          = "awspostgres"
  host            = data.aws_rds_cluster.development.endpoint
  port            = 5432
  username        = data.aws_rds_cluster.development.master_username
  password        = var.database_password
  sslmode         = "require"
  connect_timeout = 15
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.main.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.main.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.main.token
}
provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.main.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.main.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.main.token
  }
}