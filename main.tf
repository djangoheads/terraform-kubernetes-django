terraform {
  required_version = ">= 0.14.11"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.24"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.10"
    }

    helm = {
      source  = "hashicorp/helm"
    }
  }
}
