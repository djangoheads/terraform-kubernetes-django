variable "image" {
  type      = string
  sensitive = true
}

variable "database_password" {
  type      = string
  sensitive = true
}


variable "aws_eks_cluster_name" {
  type    = string
  default = "development"
}

variable "env_vars" {
  type = map(string)
}

variable "namespace" {
  type      = string
  sensitive = true
  default = "dev"
}

variable "aws_role" {
  type      = string
  sensitive = true
  default = "arn:aws:iam::123456789012:role/eks-admin"  
}

variable "aws_region" {
  type      = string
  sensitive = true
  default = "eu-central-1" 
}