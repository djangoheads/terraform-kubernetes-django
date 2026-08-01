variable "namespace" {
  type        = string
  description = "Kubernetes namespace where the Gateway resources are created."
}

variable "name" {
  type        = string
  description = "Gateway resource name."
}

variable "gateway_class_name" {
  type        = string
  description = "GKE GatewayClass name."
  default     = "gke-l7-global-external-managed"
}

variable "certificate_map_name" {
  type        = string
  description = "Certificate Manager certificate map name attached to the Gateway."
}

variable "annotations" {
  type        = map(string)
  description = "Additional annotations for the Gateway."
  default     = {}
}

variable "labels" {
  type        = map(string)
  description = "Labels applied to Gateway resources."
  default     = {}
}

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
  description = "Host and path routing rules."
}

variable "health_checks" {
  type = map(object({
    port                = number
    request_path        = string
    check_interval_sec  = optional(number, 15)
    timeout_sec         = optional(number, 5)
    healthy_threshold   = optional(number, 2)
    unhealthy_threshold = optional(number, 2)
    log_enabled         = optional(bool, false)
  }))
  description = "HTTP health checks keyed by Kubernetes Service name."
  default     = {}
}
