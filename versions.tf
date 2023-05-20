terraform {
  required_version = ">= 0.14.6"

  required_providers {
    aws = {
      source  = "hashicorp/template"
      version = ">= 2.2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.20"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.9"
    }
  }
}