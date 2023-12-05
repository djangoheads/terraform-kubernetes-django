terraform {
  required_version = ">= 0.14.6"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.20"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.9"
    }

    helm = {
      source  = "hashicorp/helm"
    }
  }
}
