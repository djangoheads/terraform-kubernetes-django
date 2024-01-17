variable "namespace" {
    type = string
}

variable "name" {
    type = string
}

variable "cloud" {
    type = string
}

# Ingress Specific Variables

variable "rules" {
  type = list(object({
    host = string
    paths = list(object({
      path = string
      backend = object({
        service = string
        port    = number
      })
    }))
  }))
  default = [{
    host = "*"
    paths = [{
      path = "/"
      backend = {
        service = 8000
        port    = 80
      }
    }]
  }]
  description = "Ingress rules to be created"
}

# AWS Specific Variables

variable "aws" {
  type = object({
    certificate = string
  })
  default = null
}
variable "aws_annotation" {
  type = map(string)
  default = {
    "alb.ingress.kubernetes.io/scheme"                   = "internet-facing"
    "kubernetes.io/ingress.class"                        = "alb"
    "alb.ingress.kubernetes.io/listen-ports"             = "[{\"HTTPS\":443}]"
    "alb.ingress.kubernetes.io/certificate-arn"          = var.aws.certificate
    "alb.ingress.kubernetes.io/load-balancer-attributes" = "routing.http.preserve_host_header.enabled=true"
  }
}

